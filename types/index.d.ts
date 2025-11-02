interface GhostscriptModule extends EmscriptenModule {
  callMain(args?: string[]): number;
  FS: typeof FS;
}

type GhostscriptModuleFactory = EmscriptenModuleFactory<GhostscriptModule>;

declare const Module: GhostscriptModuleFactory;
export default Module;
export type { GhostscriptModule, GhostscriptModuleFactory };
