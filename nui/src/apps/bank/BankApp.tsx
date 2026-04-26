// nui/src/apps/bank/BankApp.tsx
import { useState, useEffect } from 'react';
import { fetchNui } from '../../utils/nui';
import { BankStatement } from '../../types/apps';
import { ArrowUpRight, ArrowDownLeft, Send, History } from 'lucide-react';

export default function BankApp() {
  const [balance, setBalance] = useState<number>(0);
  const [statements, setStatements] = useState<BankStatement[]>([]);
  const [tab, setTab] = useState<'home' | 'pix'>('home');

  // Form states
  const [targetId, setTargetId] = useState('');
  const [amountPix, setAmountPix] = useState('');
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    loadBankData();
  }, []);

  const loadBankData = async () => {
    const res = await fetchNui<{ ok: boolean; data: { balance: number, statements: BankStatement[] } }>('vn_get_bank');
    if (res.ok && res.data) {
      setBalance(res.data.balance);
      setStatements(res.data.statements);
    }
  };

  const handleSendPix = async () => {
    if (!targetId || !amountPix || isNaN(Number(amountPix))) return;
    setLoading(true);
    
    const res = await fetchNui<{ ok: boolean; error?: string, balance?: number }>('vn_bank_transfer', {
      targetId: Number(targetId),
      amount: Number(amountPix),
      reason: 'Transferência via Passaporte'
    });

    setLoading(false);
    
    if (res.ok) {
      setTargetId('');
      setAmountPix('');
      setTab('home');
      loadBankData(); // Recarrega extrato
    } else {
      alert(res.error || "Erro ao transferir");
    }
  };

  const formatMoney = (val: number) => {
    return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(val);
  };

  const formatDate = (timestamp: number) => {
    // Timestamp Lua vem em segundos, JS espera milisegundos
    const d = new Date(timestamp * 1000); 
    return `${d.getDate().toString().padStart(2, '0')}/${(d.getMonth()+1).toString().padStart(2, '0')} - ${d.getHours().toString().padStart(2, '0')}:${d.getMinutes().toString().padStart(2, '0')}`;
  };

  return (
    <div className="w-full h-full bg-[#121214] text-white flex flex-col font-sans">
      
      {/* HEADER: SALDO */}
      <div className="bg-[#1C1C1E] p-8 pt-16 rounded-b-[40px] shadow-lg flex flex-col gap-1 relative overflow-hidden">
        <div className="absolute top-[-50px] right-[-50px] w-48 h-48 bg-blue-600/20 blur-[50px] rounded-full pointer-events-none" />
        <span className="text-gray-400 font-medium tracking-wide z-10">Saldo disponível</span>
        <h1 className="text-4xl font-bold tracking-tight z-10">{formatMoney(balance)}</h1>
        
        <div className="flex gap-4 mt-6 z-10">
          <button 
            onClick={() => setTab('pix')}
            className="flex-1 bg-blue-600 text-white font-semibold py-3 rounded-2xl flex items-center justify-center gap-2 active:bg-blue-700 transition"
          >
            <Send size={18} />
            Transferir
          </button>
          <button 
            onClick={() => setTab('home')}
            className="flex-1 bg-white/10 text-white font-semibold py-3 rounded-2xl flex items-center justify-center gap-2 active:bg-white/20 transition"
          >
            <History size={18} />
            Extrato
          </button>
        </div>
      </div>

      {/* CONTEÚDO PRINCIPAL */}
      <div className="flex-1 overflow-y-auto p-6 pt-4">
        
        {tab === 'home' && (
          <div className="flex flex-col gap-4 pb-12">
            <h2 className="text-lg font-bold mb-2">Transações Recentes</h2>
            
            {statements.length === 0 ? (
              <div className="text-center text-gray-500 mt-4">Nenhuma movimentação.</div>
            ) : (
              statements.map((stmt) => {
                return (
                  <div key={stmt.id} className="flex justify-between items-center bg-[#1C1C1E] p-4 rounded-2xl">
                    <div className="flex items-center gap-4">
                      <div className="w-10 h-10 rounded-full bg-white/5 flex items-center justify-center text-gray-400">
                        <ArrowUpRight size={18} />
                      </div>
                      <div className="flex flex-col">
                        <span className="font-medium">{stmt.reason}</span>
                        <span className="text-xs text-gray-500">{formatDate(stmt.time)}</span>
                      </div>
                    </div>
                    <span className="font-bold text-[var(--vn-primary)]">
                      ${stmt.amount}
                    </span>
                  </div>
                );
              })
            )}
          </div>
        )}

        {tab === 'pix' && (
          <div className="flex flex-col gap-4 pt-2">
            <h2 className="text-xl font-bold mb-2">Realizar Transferência</h2>
            
            <div className="flex flex-col gap-1">
              <label className="text-sm text-gray-400 ml-1">Passaporte (ID do Destino)</label>
              <input 
                type="number" 
                value={targetId}
                onChange={(e) => setTargetId(e.target.value)}
                placeholder="Ex: 123" 
                className="w-full bg-[#1C1C1E] border border-white/5 rounded-2xl px-4 py-4 text-lg focus:outline-none focus:border-blue-500 transition"
              />
            </div>

            <div className="flex flex-col gap-1 mt-2">
              <label className="text-sm text-gray-400 ml-1">Valor</label>
              <input 
                type="number" 
                value={amountPix}
                onChange={(e) => setAmountPix(e.target.value)}
                placeholder="$ 0.00" 
                className="w-full bg-[#1C1C1E] border border-white/5 rounded-2xl px-4 py-4 text-xl font-bold focus:outline-none focus:border-blue-500 transition"
              />
            </div>

            <button 
              onClick={handleSendPix}
              disabled={loading || !targetId || !amountPix}
              className="mt-6 w-full bg-blue-600 text-white font-bold py-4 rounded-2xl active:bg-blue-700 transition disabled:opacity-50"
            >
              {loading ? "Processando..." : "Confirmar Transferência"}
            </button>
            <button 
              onClick={() => setTab('home')}
              className="mt-2 w-full text-gray-400 font-semibold py-4 rounded-2xl hover:text-white transition"
            >
              Cancelar
            </button>
          </div>
        )}
      </div>
    </div>
  );
}