// nui/src/types/apps.ts

export interface Contact {
  id: number;
  owner: string;
  phone: string;
  name: string;
}

export interface BankStatement {
  id: number;
  pix: string;
  from: string;
  source: string;
  type: string;
  amount: number;
  reason: string;
  time: number;
}

export interface ChatChannel {
  id: number;
  sender: string;
  target: string;
}

export interface ChatMessage {
  id: number;
  channel_id: number;
  sender: string;
  content: string;
  created_at: number;
}