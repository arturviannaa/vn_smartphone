import { create } from 'zustand'

export type AppId = 'phone' | 'messages' | 'bank' | 'gallery' | 'instagram' | 'tinder' | 'tor' | 'olx' | 'weazel' | 'uber' | 'ifood' | 'casino' | 'settings' | null

interface PhoneState {
  isOpen: boolean;
  currentApp: AppId;
  isLocked: boolean;
  open: () => void;
  close: () => void;
  openApp: (app: AppId) => void;
  closeApp: () => void;
  unlock: () => void;
}

export const usePhoneStore = create<PhoneState>((set) => ({
  isOpen: false,
  currentApp: null,
  isLocked: true,
  open: () => set({ isOpen: true }),
  close: () => set({ isOpen: false, currentApp: null, isLocked: true }),
  openApp: (app) => set({ currentApp: app }),
  closeApp: () => set({ currentApp: null }),
  unlock: () => set({ isLocked: false }),
}))