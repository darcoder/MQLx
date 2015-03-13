//+------------------------------------------------------------------+
//|                                                        Order.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Arrays\ArrayInt.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JOrder : public JOrderBase
  {
protected:
   CArrayInt         m_ticket_current;
   bool              m_ticket_updated;
public:
                     JOrder(void);
                     JOrder(const ulong ticket,const ENUM_ORDER_TYPE type,const double volume,const double price);
                    ~JOrder(void);
   virtual bool      IsClosed(void);
   virtual void      Ticket(const ulong ticket) {m_ticket_current.InsertSort((int)ticket);}
   virtual ulong     Ticket(void) const {return(m_ticket_current.At(m_ticket_current.Total()-1));}
   virtual void      NewTicket(const bool updated) {m_ticket_updated=updated;}
   virtual bool      NewTicket(void) const {return(m_ticket_updated);}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrder::JOrder(void): m_ticket_updated(false)
  {  
   if (!m_ticket_current.IsSorted()) 
      m_ticket_current.Sort(); 
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrder::JOrder(const ulong ticket,const ENUM_ORDER_TYPE type,const double volume,const double price)
  {
   if (!m_ticket_current.IsSorted()) 
      m_ticket_current.Sort();
   m_ticket=ticket;
   m_ticket_current.InsertSort((int)ticket);
   m_type=type;
   m_volume_initial=volume;
   m_volume= m_volume_initial;
   m_price = price;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JOrder::~JOrder(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JOrder::IsClosed(void)
  {
   if(m_closed) return(true);
   if(Volume()<=0.0)
     {
      m_closed=true;
      return(true);
     }
   else
     {
      if(OrderSelect((int)Ticket(),SELECT_BY_TICKET))
         if(OrderCloseTime()>0)
           {
            m_closed=true;
            return(true);
           }
     }
   return(false);
  }
//+------------------------------------------------------------------+
