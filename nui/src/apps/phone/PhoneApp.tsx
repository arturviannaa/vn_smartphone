// nui/src/apps/phone/PhoneApp.tsx
import { useState, useEffect } from 'react';
import { fetchNui } from '../../utils/nui';
import { Contact } from '../../types/apps';
import { Clock, Users, Grip, Phone as PhoneIcon, Plus } from 'lucide-react';

export default function PhoneApp() {
  const [activeTab, setActiveTab] = useState<'recents' | 'contacts' | 'keypad'>('keypad');
  const [contacts, setContacts] = useState<Contact[]>([]);
  const [displayNumber, setDisplayNumber] = useState('');

  // Carrega contatos ao abrir o app
  useEffect(() => {
    fetchNui<{ ok: boolean; data: Contact[] }>('vn_get_contacts').then((res) => {
      if (res.ok && res.data) setContacts(res.data);
    });
  }, []);

  const handleDial = (num: string) => {
    if (displayNumber.length < 15) setDisplayNumber(prev => prev + num);
  };

  const handleCall = () => {
    if (!displayNumber) return;
    console.log("Ligando para:", displayNumber);
    // TODO: fetchNui('vn_make_call', { target: displayNumber })
  };

  return (
    <div className="w-full h-full bg-black text-white flex flex-col pt-12">
      
      {/* CONTEÚDO DAS ABAS */}
      <div className="flex-1 overflow-y-auto px-6">
        
        {/* ABA: TECLADO */}
        {activeTab === 'keypad' && (
          <div className="flex flex-col items-center justify-center h-full pt-10">
            <div className="h-[80px] flex items-center justify-center text-4xl font-light mb-8">
              {displayNumber || ' '}
            </div>
            
            <div className="grid grid-cols-3 gap-x-6 gap-y-4 mb-10">
              {[1,2,3,4,5,6,7,8,9,'*',0,'#'].map((key) => (
                <button 
                  key={key} 
                  onClick={() => handleDial(key.toString())}
                  className="w-[75px] h-[75px] bg-[#333333] rounded-full text-4xl font-light active:bg-[#555555] transition-colors"
                >
                  {key}
                </button>
              ))}
            </div>

            <div className="flex gap-6 items-center">
              <div className="w-[75px]" /> {/* Spacer */}
              <button 
                onClick={handleCall}
                className="w-[75px] h-[75px] bg-green-500 rounded-full flex items-center justify-center active:bg-green-600 transition-colors"
              >
                <PhoneIcon fill="white" size={32} />
              </button>
              <button 
                onClick={() => setDisplayNumber(prev => prev.slice(0, -1))}
                className="w-[75px] h-[75px] flex items-center justify-center text-xl text-gray-400 active:text-white"
              >
                {displayNumber ? '⌫' : ''}
              </button>
            </div>
          </div>
        )}

        {/* ABA: CONTATOS */}
        {activeTab === 'contacts' && (
          <div className="flex flex-col h-full">
            <div className="flex justify-between items-center mb-6">
              <h1 className="text-3xl font-bold">Contatos</h1>
              <Plus size={28} className="text-[var(--vn-primary)] cursor-pointer" />
            </div>
            {contacts.length === 0 ? (
              <div className="text-center text-gray-500 mt-10">Nenhum contato salvo</div>
            ) : (
              <div className="flex flex-col gap-4">
                {contacts.map(c => (
                  <div key={c.id} className="flex justify-between items-center border-b border-[#222] pb-2">
                    <span className="font-medium text-lg">{c.name}</span>
                    <span className="text-gray-400">{c.phone}</span>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}

        {/* ABA: RECENTES */}
        {activeTab === 'recents' && (
          <div className="flex flex-col h-full">
            <h1 className="text-3xl font-bold mb-6">Recentes</h1>
            <div className="text-center text-gray-500 mt-10">Nenhuma chamada recente</div>
          </div>
        )}
      </div>

      {/* BARRA DE NAVEGAÇÃO INFERIOR */}
      <div className="h-[85px] bg-[#1c1c1e]/90 backdrop-blur-md border-t border-[#333] flex justify-between px-8 pt-2 pb-6">
        <NavButton icon={Clock} label="Recentes" isActive={activeTab === 'recents'} onClick={() => setActiveTab('recents')} />
        <NavButton icon={Users} label="Contatos" isActive={activeTab === 'contacts'} onClick={() => setActiveTab('contacts')} />
        <NavButton icon={Grip} label="Teclado" isActive={activeTab === 'keypad'} onClick={() => setActiveTab('keypad')} />
      </div>
    </div>
  );
}

function NavButton({ icon: Icon, label, isActive, onClick }: any) {
  return (
    <div onClick={onClick} className={`flex flex-col items-center gap-1 cursor-pointer transition-colors ${isActive ? 'text-[var(--vn-primary)]' : 'text-gray-500'}`}>
      <Icon size={24} />
      <span className="text-[10px] font-medium">{label}</span>
    </div>
  );
}