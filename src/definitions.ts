export interface DensoScannerPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
