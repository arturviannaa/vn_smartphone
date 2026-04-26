import { useEffect } from 'react'

export function useNuiEvent<T = any>(action: string, handler: (data: T) => void) {
  useEffect(() => {
    const listener = (event: MessageEvent) => {
      if (event.data?.action === action) {
        handler(event.data.data ?? event.data);
      }
    }
    window.addEventListener('message', listener);
    return () => window.removeEventListener('message', listener);
  }, [action, handler]);
}