# Enhanced Cutting Diagram v3.0 — Software Design Description (SDD)

This document describes the current design of the single‑page web application found in `115 fixed .html` and proposes a clean modular structure with function names to guide further development.

## Overview

The app generates optimized cutting diagrams from two CSV files (Cutting List and Board Master), renders interactive SVG layouts per material and sheet, and supports label printing (browser and Zebra ZT230 via BrowserPrint). It persists user settings and projects in localStorage and offers keyboard shortcuts, dark mode, and analytics.

## Scope and goals

- Import CSVs, validate, and normalize data
- Group parts by material and nest them into sheets based on board sizes
- Visualize boards/sheets and parts in SVG with pan/zoom and selection
- Print entire sheets (browser) and individual labels (browser or Zebra ZPL)
- Save/load projects and settings (localStorage)
- Provide helpful status, progress, and error notifications

## External dependencies

- Zebra Browser Print SDK (via `https://localhost:9101/BrowserPrint-3.0.216.min.js`)
- jsPDF (via CDN) for PDF export

If the BrowserPrint service is not installed/running, Zebra printing will be unavailable.

## Data model (runtime state)

- Part (from cutting CSV)
  - name: string (CSV `Name`)
  - length: number (CSV `Length`, mm)
  - width: number (CSV `Width`, mm)
  - quantity: number (CSV `Quantity`)
  - material: string (CSV `Material`)
  - rotate: string ('0' | '1' | '2') (CSV `Can Rotate (0 = No / 1 = Yes / 2 = Same As Material)`)
  - edging: object with optional `el1`, `el2`, `ew1`, `ew2`
  - notes1/notes2: optional
  - __csvIndex: number (internal)
  - __instance: number (expanded quantity index)

- BoardSize (from master CSV)
  - length: number
  - width: number

- PlacedPart (per sheet)
  - x, y: number (mm; top-left)
  - l, w: number (mm; placed dimensions, may reflect rotation)
  - rotated: boolean
  - comp: Part (original)
  - idx: number (CSV index)
  - instance: number
  - wasteScore: number (placement heuristic)

- Settings (persisted as `cuttingDiagramSettings`)
  - labelFontSize: number
  - labelBold: boolean
  - labelMargin: number (mm)
  - kerfWidth: number (mm)
  - minOffcutL/minOffcutW: number (mm)
  - grainPriority: 'none' | 'length' | 'width' | 'material'
  - nestingAlgorithm: 'maxrect' | 'bottom_left' | 'best_fit'
  - printerType: string
  - labelSize: '4x2' | '4x3' | '4x6'

- Project state (persisted in `savedProjects[<name>]` and `autoSave`)
  - currentBoards: string[] (material keys)
  - currentGroups: { [material]: Part[] }
  - currentSheets: { [material]: PlacedPart[][] }
  - currentSheetPage: { [material]: number }
  - originalParts: Part[]
  - partPlacementMap: { [material]: { ["idx_instance"]: { page, pi } } }
  - boardSizes: { [material]: BoardSize & { warn?: boolean } }
  - masterBoardDB: { [material]: BoardSize }
  - printedParts: { ["material_page_pi"]: true }
  - completedPages: { [material]: boolean[] }
  - settings: Settings

- Other localStorage keys
  - `cutPin` (4-digit string)
  - `darkMode` ('true' | 'false')

## CSV schemas (required headers)

- Cutting List CSV
  - Name, Length, Width, Quantity, Material
  - Optional: Can Rotate (0 = No / 1 = Yes / 2 = Same As Material), Edging Length 1/2, Edging Width 1/2, Notes 1/2

- Board Master CSV
  - Material, `board length  `, `board width  ` (note: includes two trailing spaces in the header names, as per current code)

## Architecture and modules (current vs proposed)

Current
- Single HTML file with inline CSS and JS; global functions and state in window scope.

Proposed modular structure
- src/
  - core/
    - csv.ts: parse & normalize CSVs
    - nesting.ts: placement algorithms
    - zpl.ts: ZPL label generation (ZT230)
    - state.ts: app state types and helpers
  - services/
    - printer.ts: BrowserPrint discovery, status, and send
    - storage.ts: settings + projects persistence
    - pdf.ts: jsPDF integration
  - ui/
    - render.ts: main view rendering (SVG, side panel, controls)
    - tabs.ts: tabs and navigation
    - interactions.ts: pan/zoom, resize divider, keyboard
    - popups.ts: settings/help/project/label popups
    - notifications.ts: toasts
  - analytics/
    - usage.ts: material utilization report
  - index.ts: app bootstrap
- public/
  - index.html (loads bundled assets)

This mapping keeps concerns separated and simplifies testing.

## Key UI components and DOM anchors

- Header controls: `#header-row` (file inputs, process, settings/help/dark mode)
- Tabs: `#tabs` (materials)
- Content: `#tab-content` (SVG board + side panel + controls)
- SVG canvas: `#svgMain` wrapping `#svgPan` for transform
- Popups: `#settingsPopup`, `#helpPopup`, `#projectPopup`, generic `#popup` + `#overlay`
- Notifications: `#notifications`
- Progress: `#progressContainer` with `#progressFill` and `#progressText`

## Event flows

1) Process CSVs
- Click Process → readFileAsync(cutting, master)
- processMasterCSV → build `masterBoardDB`
- processCuttingCSV → validate, groupByBoard, expandQuantities, nestComponentsOnBoards → build `currentSheets`, `boardSizes`, `currentSheetPage`, `partPlacementMap`
- updateTabsUI → selectTab(0) → renderMainView

2) Render & Interact
- renderMainView → renderSVGDiagram + renderSidePanel + renderControls
- initializeInteractions → divider resize + SVG pan/zoom/multi-touch; keyboard shortcuts → navigateSheet/zoom/reset/dark mode
- highlightComponent syncs selection between SVG and side list

3) Printing
- printAllSheets → generatePrintPage for each sheet → browser print dialog
- showComponentPopup → printBrowserLabel or printZebraLabel → markPartAsPrinted; generateZT230ZPL builds ZPL
- Zebra printing requires discoverZebraPrinter success

4) Persistence
- Settings: loadSettings/saveSettings/updateSettingsUI
- Projects: save/load/delete via localStorage; auto-save every 30s; optional restore on load

5) Analytics
- generateAnalyticsReport computes overall/m per-material utilization

## Function catalog (as implemented)

Core CSV & models
- parseCSV(csvString): string[][] — tolerant parser with progress
- getHeaders(rows): string[] — first row
- buildObjects(rows, headers): object[] — rows to objects; progress
- escapeHtml(str): string — output encoding
- groupByBoard(objects): { [material]: object[] }
- expandQuantities(objects): object[] — duplicates by `Quantity`

Nesting algorithms
- nestComponentsOnBoards(components, kerf, BL, BW, algorithm): PlacedPart[][]
- nestMaximalRectangles(components, kerf, BL, BW): PlacedPart[][]
- nestBottomLeft(components, kerf, BL, BW): PlacedPart[][]
- nestBestFit(components, kerf, BL, BW): PlacedPart[][] (currently aliases to maxrect)

Processing pipeline
- readFileAsync(file): Promise<string>
- processMasterCSV(text): Promise<void>
- processCuttingCSV(text): Promise<void>
- resetUI(): void

Status & progress
- showProgress(percent, message?): void
- hideProgress(): void
- showError/showSuccess/showInfo(message): void
- showNotification(message, type, duration?): toast

Tabs + rendering
- updateTabsUI(): void
- updateHeaderButtons(): void
- window.selectTab(idx): void → renderMainView(...)
- renderMainView(key, page, sheets, BL, BW, errorFlag): void
- renderSVGDiagram(key, page, sheets, BL, BW, svgW, svgH, PAD): string
- renderSidePanel(key, page, sheets, errorFlag): string
- renderControls(key, sheets, page, errorFlag): string

Selection + labels
- window.highlightComponent(boardKey, pageIdx, pi): void
- window.showComponentPopup(boardKey, pageIdx, pi): void
- printBrowserLabel(comp, material, length, width, el1, el2, ew1, ew2, svg): void
- printZebraLabel(comp, material, length, width, edging): void
- markPartAsPrinted(boardKey, pageIdx, pi): void

Navigation & zoom
- window.goToSheet(key, pageIdx): void
- window.completeCurrentSheet(key, pageIdx): void
- window.resetAllComplete(): void
- window.zoomSvg(dir): void
- window.resetSvgPanZoom(): void

Interactions
- initializeInteractions(svgW, svgH): void
- initializePanelResize(): void (divider)
- initializeSVGInteractions(): void (drag, wheel zoom, touch)
- window.hidePopup(): void

Printing (sheets)
- window.printAllSheets(): void
- generatePrintPage(boardKey, pageIndex, parts, BL, BW, scale, PAD): string

Settings & projects
- initializeSettings(): void
- closeSettings(): void
- updatePrinterStatus(): void (auto-discover)
- loadSavedProjects(): void (populate list)

Keyboard helper
- navigateSheet(direction): void

D&D helpers
- initializeDragDrop(): void
- createFileList(files): FileList

Analytics
- generateAnalyticsReport(): AggregateStats | null

Zebra integration & ZPL
- discoverZebraPrinter(callback: (found: boolean) => void): void
- generateZT230ZPL(componentData, settings?): string
- testZebraPrint(): void

Public API (exported to window)
- nestComponentsOnBoards, generateAnalyticsReport, showNotification, appSettings, saveSettings, zebraPrinter, discoverZebraPrinter, testZebraPrint, getPerformanceMetrics

## Error handling

- Centralized toasts with levels (error/success/info/warning)
- Global `error`/`unhandledrejection` listeners to surface unexpected issues
- CSV header validation throws descriptive errors

## Non-functional requirements

- Performance: Progressive status updates; greedy nesting in JS; avoid reflow loops; SVG sized for responsiveness
- Usability: Keyboard shortcuts; dark mode; drag/drop; clear toasts and progress bar
- Compatibility: Modern browsers; Zebra printing requires BrowserPrint on `https://localhost:9101`
- Print correctness: Dedicated print CSS; sheet summary + table included
- Accessibility (opportunities): Add ARIA roles, focus management for popups, improved keyboard nav on parts list

## Proposed refactor plan (incremental)

1) Extract JS from HTML to `src/` modules using ES modules or TypeScript; add a lightweight bundler (Vite)
2) Introduce types for Part/BoardSize/PlacedPart/Settings
3) Unit tests for: csv parsing, grouping/expansion, max-rect placement, ZPL generation
4) UI refactor: isolate rendering from state; consider a simple view state store
5) Replace hard-coded board master headers (with trailing spaces) by robust header normalizer
6) Improve nesting strategies (true best-fit; material grain rules)
7) Add error boundaries for popups and long operations (e.g., abort controls)

### Suggested file map (from current functions)

- core/csv.ts
  - parseCSV, buildObjects, escapeHtml, groupByBoard, expandQuantities, getHeaders
- core/nesting.ts
  - nestComponentsOnBoards, nestMaximalRectangles, nestBottomLeft, nestBestFit
- core/zpl.ts
  - generateZT230ZPL
- services/printer.ts
  - discoverZebraPrinter, testZebraPrint, printZebraLabel
- services/storage.ts
  - loadSettings, saveSettings, updateSettingsUI (UI-binding hooks), project save/load/delete, auto-save
- services/pdf.ts
  - export current sheets to PDF (wrap jsPDF)
- ui/render.ts
  - renderMainView, renderSVGDiagram, renderSidePanel, renderControls
- ui/tabs.ts
  - updateTabsUI, selectTab, goToSheet, completeCurrentSheet, resetAllComplete
- ui/interactions.ts
  - initializePanelResize, initializeSVGInteractions, zoomSvg, resetSvgPanZoom, keyboard shortcuts, navigateSheet
- ui/popups.ts
  - showComponentPopup, hidePopup, settings/help/project popups
- ui/notifications.ts
  - showNotification, showError/showSuccess/showInfo
- analytics/usage.ts
  - generateAnalyticsReport

## Testing strategy (minimal)

- Unit
  - csv: commas/quotes/semicolons, BOM, empty rows
  - nesting: placement non-overlap, bounds, kerf accounting, rotation rules
  - zpl: presence of fields; proper label width/height; edging markers
- Integration
  - process pipeline: small sample CSVs → non-empty sheets; tabs render
  - print page generation: deterministic HTML snippets
- Smoke (optional Playwright)
  - Upload CSVs, navigate tabs/sheets, print dialog opens

## Next steps

- Decide on bundling (ESM + Vite) and TypeScript adoption
- Extract code into modules following the map above
- Add unit tests and a small sample dataset under `fixtures/`
- Improve Best-Fit algorithm and grain handling
- Enhance accessibility for popups and keyboard focus management

---

If you want, I can scaffold the proposed `src/` structure and start extracting modules with types and tests.
