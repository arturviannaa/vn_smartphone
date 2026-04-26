// nui/src/apps/messages/MessagesApp.tsx
import { useState, useEffect, useRef } from 'react';
import { fetchNui } from '../../utils/nui';
import { ChatChannel, ChatMessage, Contact } from '../../types/apps';
import { ChevronLeft, Edit, SendHorizontal } from 'lucide-react';

export default function MessagesApp() {
  const [view, setView] = useState<'list' | 'chat'>('list');
  const [channels, setChannels] = useState<ChatChannel[]>([]);
  const [contacts, setContacts] = useState<Contact[]>([]);
  
  // Chat state
  const [activeChannel, setActiveChannel] = useState<ChatChannel | null>(null);
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [inputText, setInputText] = useState('');
  
  // Mock do próprio número para alinhar as mensagens (No futuro puxar da Store)
  const myPhone = '555-0000'; 
  const messagesEndRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    loadInitialData();
  }, []);

  useEffect(() => {
    if (view === 'chat') {
      scrollToBottom();
    }
  }, [messages, view]);

  const loadInitialData = async () => {
    const [resChats, resContacts] = await Promise.all([
      fetchNui<{ ok: boolean; data: ChatChannel[] }>('vn_get_chats'),
      fetchNui<{ ok: boolean; data: Contact[] }>('vn_get_contacts')
    ]);

    if (resChats.ok && resChats.data) setChannels(resChats.data);
    if (resContacts.ok && resContacts.data) setContacts(resContacts.data);
  };

  const openChat = async (channel: ChatChannel) => {
    setActiveChannel(channel);
    setView('chat');
    
    // CORREÇÃO AQUI: Enviando como um objeto em vez de número solto
    const res = await fetchNui<{ ok: boolean; data: ChatMessage[] }>('vn_get_messages', { channel_id: channel.id });
    if (res.ok && res.data) {
      setMessages(res.data);
    }
  };

  const handleSend = async () => {
    if (!inputText.trim() || !activeChannel) return;
    
    const textToSend = inputText;
    setInputText(''); // Limpa otimista

    // Mock otimista na NUI
    const tempMsg: ChatMessage = {
      id: Date.now(),
      channel_id: activeChannel.id,
      sender: myPhone,
      content: textToSend,
      created_at: Math.floor(Date.now() / 1000)
    };
    setMessages(prev => [...prev, tempMsg]);

    await fetchNui('vn_send_message', {
      channel_id: activeChannel.id,
      content: textToSend
    });
  };

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };

  const getContactName = (phone: string) => {
    const contact = contacts.find(c => c.phone === phone);
    return contact ? contact.name : phone;
  };

  return (
    <div className="w-full h-full bg-black text-white flex flex-col">
      
      {/* TELA DE LISTA DE CONVERSAS */}
      {view === 'list' && (
        <>
          <div className="pt-16 px-6 pb-4 flex justify-between items-center bg-[#1c1c1e]/90 backdrop-blur-md z-10 sticky top-0 border-b border-[#333]">
            <span className="text-[var(--vn-primary)] text-lg cursor-pointer">Editar</span>
            <Edit size={22} className="text-[var(--vn-primary)] cursor-pointer" />
          </div>
          <div className="px-6 py-2">
            <h1 className="text-3xl font-bold mb-4">Mensagens</h1>
            
            <div className="flex flex-col gap-0">
              {channels.length === 0 ? (
                <div className="text-gray-500 text-center mt-10">Nenhuma conversa.</div>
              ) : (
                channels.map((ch) => {
                  const targetPhone = ch.sender === myPhone ? ch.target : ch.sender;
                  const displayName = getContactName(targetPhone);

                  return (
                    <div 
                      key={ch.id} 
                      className="flex items-center gap-4 py-3 border-b border-[#222] cursor-pointer active:bg-white/5 transition"
                      onClick={() => openChat(ch)}
                    >
                      <div className="w-12 h-12 bg-gradient-to-tr from-green-400 to-green-600 rounded-full flex items-center justify-center font-bold text-lg shadow-sm">
                        {displayName.charAt(0).toUpperCase()}
                      </div>
                      <div className="flex-1 flex flex-col">
                        <span className="font-semibold text-white">{displayName}</span>
                        <span className="text-sm text-gray-500 truncate">Toque para ver mensagens</span>
                      </div>
                    </div>
                  )
                })
              )}
            </div>
          </div>
        </>
      )}

      {/* TELA DE CHAT (DENTRO DA CONVERSA) */}
      {view === 'chat' && activeChannel && (
        <div className="flex flex-col h-full bg-[#0a0a0c]">
          <div className="pt-14 px-4 pb-3 flex items-center gap-3 bg-[#1c1c1e]/90 backdrop-blur-md z-10 border-b border-[#333]">
            <div className="flex items-center gap-1 text-[var(--vn-primary)] cursor-pointer" onClick={() => setView('list')}>
              <ChevronLeft size={28} />
              <span className="text-lg">Voltar</span>
            </div>
            <div className="flex-1 flex justify-center">
              <div className="flex flex-col items-center">
                <div className="w-8 h-8 bg-gradient-to-tr from-green-400 to-green-600 rounded-full flex items-center justify-center font-bold text-xs mb-1 shadow-sm">
                  {getContactName(activeChannel.sender === myPhone ? activeChannel.target : activeChannel.sender).charAt(0).toUpperCase()}
                </div>
                <span className="text-xs font-medium">
                  {getContactName(activeChannel.sender === myPhone ? activeChannel.target : activeChannel.sender)}
                </span>
              </div>
            </div>
            <div className="w-[80px]" />
          </div>

          {/* Área de Mensagens */}
          <div className="flex-1 overflow-y-auto px-4 py-4 flex flex-col gap-3">
            {messages.map((msg) => {
              const isMe = msg.sender === myPhone;
              return (
                <div key={msg.id} className={`flex ${isMe ? 'justify-end' : 'justify-start'}`}>
                  <div className={`max-w-[75%] px-4 py-2.5 rounded-[20px] text-[15px] leading-snug shadow-sm ${
                    isMe 
                    ? 'bg-green-500 text-white rounded-br-[4px]' 
                    : 'bg-[#262628] text-white rounded-bl-[4px]'
                  }`}>
                    {msg.content}
                  </div>
                </div>
              );
            })}
            <div ref={messagesEndRef} />
          </div>

          {/* Input Area */}
          <div className="px-4 py-3 bg-[#1c1c1e]/90 backdrop-blur-md border-t border-[#333] flex items-center gap-3 pb-8">
            <input 
              type="text" 
              value={inputText}
              onChange={e => setInputText(e.target.value)}
              onKeyDown={e => e.key === 'Enter' && handleSend()}
              placeholder="Mensagem..."
              className="flex-1 bg-black border border-white/10 rounded-full px-4 py-2.5 text-[15px] focus:outline-none focus:border-[var(--vn-primary)] transition"
            />
            <button 
              onClick={handleSend}
              disabled={!inputText.trim()}
              className="w-10 h-10 bg-[var(--vn-primary)] rounded-full flex items-center justify-center disabled:opacity-50 active:scale-95 transition"
            >
              <SendHorizontal size={18} className="text-white ml-0.5" />
            </button>
          </div>
        </div>
      )}

    </div>
  );
}