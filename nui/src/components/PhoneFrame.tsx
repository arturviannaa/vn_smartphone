import { ReactNode } from 'react';
import StatusBar from './StatusBar';
import HomeIndicator from './HomeIndicator';
import { fetchNui } from '../utils/nui';
import { usePhoneStore } from '../store/phoneStore';

export default function PhoneFrame({ children }: { children: ReactNode }) {
  const close = usePhoneStore((s) => s.close);

  const handlePowerButton = () => {
    fetchNui('vn_close');
    close(); 
  };

  return (
    <div className="relative flex items-center justify-center">
      {/* Botões Físicos Esquerda (Em -17px para vencer a sombra de 14px da carcaça) */}
      <div 
        className="absolute left-[-17px] top-[140px] w-[5px] h-[30px] bg-[#2a2a2c] rounded-l-[4px] shadow-inner border-y border-l border-white/5" 
        title="Action Button" 
      />
      <div 
        className="absolute left-[-17px] top-[200px] w-[5px] h-[60px] bg-[#2a2a2c] rounded-l-[4px] shadow-inner border-y border-l border-white/5" 
        title="Volume Up" 
      />
      <div 
        className="absolute left-[-17px] top-[275px] w-[5px] h-[60px] bg-[#2a2a2c] rounded-l-[4px] shadow-inner border-y border-l border-white/5" 
        title="Volume Down" 
      />
      
      {/* Botão Físico Direita (Power / Lock) */}
      <div 
        className="absolute right-[-17px] top-[220px] w-[5px] h-[90px] bg-[#2a2a2c] rounded-r-[4px] shadow-inner border-y border-r border-white/5 cursor-pointer hover:bg-[#5a5a5c] active:bg-[#7a7a7c] transition-colors z-50"
        onClick={handlePowerButton}
        title="Bloquear / Fechar"
      />

      {/* Casca principal do telefone */}
      <div className="relative w-[400px] h-[830px] bg-black rounded-[55px] shadow-[0_0_0_12px_#1a1a1c,0_0_0_14px_#3a3a3c,5px_20px_40px_rgba(0,0,0,0.5)] overflow-hidden flex flex-col text-white z-10">
        
        {/* A StatusBar (que contém a DynamicIsland) sempre fica acima dos apps */}
        <StatusBar />
        
        <main className="flex-1 relative overflow-hidden">
          {children}
        </main>
        
        <HomeIndicator />
      </div>
    </div>
  );
}