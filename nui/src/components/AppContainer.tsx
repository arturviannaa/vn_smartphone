import { usePhoneStore } from '../store/phoneStore';
import { motion, AnimatePresence } from 'framer-motion';

import PhoneApp from '../apps/phone/PhoneApp';
import BankApp from '../apps/bank/BankApp';
import MessagesApp from '../apps/messages/MessagesApp'; // <--- IMPORT NOVO

export default function AppContainer() {
  const currentApp = usePhoneStore((s) => s.currentApp);

  const renderApp = () => {
    switch (currentApp) {
      case 'phone':
        return <PhoneApp />;
      case 'bank':
        return <BankApp />;
      case 'messages':         // <--- CASE NOVO
        return <MessagesApp />;
      default:
        return (
          <div className="w-full h-full flex flex-col items-center justify-center bg-[#121214] text-white gap-4">
            <span className="text-2xl font-semibold capitalize">{currentApp}</span>
            <span className="text-sm text-gray-500 font-normal">Em desenvolvimento...</span>
          </div>
        );
    }
  };

  return (
    <AnimatePresence>
      {currentApp && (
        <motion.div
          key="app-container"
          initial={{ scale: 0.8, opacity: 0, borderRadius: '55px' }}
          animate={{ scale: 1, opacity: 1, borderRadius: '0px' }}
          exit={{ scale: 0.8, opacity: 0, borderRadius: '55px' }}
          transition={{ type: 'spring', damping: 25, stiffness: 300 }}
          className="absolute inset-0 bg-black z-30 overflow-hidden"
        >
          {renderApp()}
        </motion.div>
      )}
    </AnimatePresence>
  );
}