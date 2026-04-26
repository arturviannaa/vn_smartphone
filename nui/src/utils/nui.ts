export const isFiveM = (): boolean => {
  return typeof window !== 'undefined' && 'GetParentResourceName' in window;
}

export async function fetchNui<T = unknown>(
  callback: string,
  data: Record<string, unknown> = {}
): Promise<T> {
  if (!isFiveM()) {
    console.log(`[Dev Mock] Fetching: ${callback}`, data);
    return { ok: true, mock: true } as T;
  }
  
  const resourceName = (window as any).GetParentResourceName?.() || 'vn_smartphone';
  const resp = await fetch(`https://${resourceName}/${callback}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  });
  return resp.json() as Promise<T>;
}