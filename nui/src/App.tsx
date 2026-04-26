import { useEffect } from 'react'
import { usePhoneStore } from './store/phoneStore'
import { useNuiEvent } from './hooks/useNuiEvent'
import { fetchNui } from './utils/nui'
import { AnimatePresence } from 'framer-motion'

import PhoneFrame from './components/PhoneFrame'
import LockScreen from './components/LockScreen'
import HomeScreen from './components/HomeScreen'
import AppContainer from './components/AppContainer'

function App() {
  const { isOpen, isLocked, open, close } = usePhoneStore()

  useNuiEvent('vn_open', () => open())
  useNuiEvent('vn_close', () => close())

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape' && isOpen) fetchNui('vn_close');
    }
    window.addEventListener('keydown', handleKeyDown)
    return () => window.removeEventListener('keydown', handleKeyDown)
  }, [isOpen])

  useEffect(() => {
    fetchNui('vn_ready');
    // REMOVER ISTO DEPOIS - Apenas para testarmos visualmente no navegador
    if (!isFiveM()) open(); 
  }, []);

  const isFiveM = () => typeof window !== 'undefined' && 'GetParentResourceName' in window;

  if (!isOpen) return null;

  return (
    <div className="w-screen h-screen flex items-end justify-end p-12 pointer-events-none pb-[5vh]">
      <div className="pointer-events-auto">
        <PhoneFrame>
          <AnimatePresence>
            {isLocked ? (
              <LockScreen key="lock" />
            ) : (
              <HomeScreen key="home" />
            )}
          </AnimatePresence>
          <AppContainer />
        </PhoneFrame>
      </div>
    </div>
  )
}

export default App