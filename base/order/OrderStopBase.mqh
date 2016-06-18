//+------------------------------------------------------------------+
//|                                                OrderStopBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "..\..\Common\Enum\ENUM_VOLUME_TYPE.mqh"
#include <Arrays\ArrayDouble.mqh>
#include "..\Trade\ExpertTradeBase.mqh"
#include "..\Stop\StopBase.mqh"
#include "..\Stop\StopLineBase.mqh"
class COrder;
class COrderStops;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrderStopBase : public CObject
  {
protected:
   bool              m_active;
   //--- stop parameters
   double            m_volume;
   CArrayDouble      m_stoploss;
   CArrayDouble      m_takeprofit;
   double            m_stoploss_initial;
   double            m_takeprofit_initial;
   ulong             m_stoploss_ticket;
   ulong             m_takeprofit_ticket;
   bool              m_stoploss_closed;
   bool              m_takeprofit_closed;
   bool              m_closed;
   ENUM_STOP_TYPE    m_stop_type;
   string            m_stop_name;
   //--- main order object
   COrder           *m_order;
   //--- stop objects
   CStop            *m_stop;
   CStopLine        *m_objentry;
   CStopLine        *m_objsl;
   CStopLine        *m_objtp;
   COrderStops      *m_order_stops;
public:
                     COrderStopBase(void);
                    ~COrderStopBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_ORDERSTOP;}
   //--- initialization
   virtual void      Init(COrder *order,CStop *stop,COrderStops *order_stops);
   virtual void      SetContainer(COrderStops *orderstops){m_order_stops=orderstops;}
   //--- getters and setters  
   bool              Active(){return m_active;}
   void              Active(bool active){m_active=active;}
   string            EntryName(void) const {return m_stop.Name()+"."+(string)m_order.Ticket();}
   ulong             MainMagic(void) const {return m_order.Magic();}
   ulong             MainTicket(void) const {return m_order.Ticket();}
   double            MainTicketPrice(void) const {return m_order.Price();}
   ENUM_ORDER_TYPE   MainTicketType(void) const {return m_order.OrderType();}
   COrder           *Order(void) {return GetPointer(m_order);}
   void              StopLoss(const double stoploss) {m_stoploss.Add(stoploss);}
   double            StopLoss(void) const {return m_stoploss.Total()>0?m_stoploss.At(m_stoploss.Total()-1):0;}
   double            StopLoss(const int index) const {return m_stoploss.Total()>index?m_stoploss.At(index):0;}
   double            StopLossLast(void) const {return m_stoploss.Total()>2?m_stoploss.At(m_stoploss.Total()-2):0;}
   string            StopLossName(void) const {return m_stop.Name()+m_stop.StopLossName()+(string)m_order.Ticket();}
   void              StopLossTicket(const ulong ticket) {m_stoploss_ticket=ticket;}
   ulong             StopLossTicket(void) const {return m_stoploss_ticket;}
   void              StopName(const string stop_name) {m_stop_name=stop_name;}
   string            StopName(void) const {return m_stop_name;}
   void              TakeProfit(const double takeprofit) {m_takeprofit.Add(takeprofit);}
   double            TakeProfit(void) const {return m_takeprofit.Total()>0?m_takeprofit.At(m_takeprofit.Total()-1):0;}
   double            TakeProfit(const int index) const {return m_takeprofit.Total()>index?m_takeprofit.At(index):0;}
   double            TakeProfitLast(void) const {return m_takeprofit.Total()>2?m_takeprofit.At(m_takeprofit.Total()-2):0;}
   string            TakeProfitName(void) const {return m_stop.Name()+m_stop.TakeProfitName()+(string)m_order.Ticket();}
   void              TakeProfitTicket(const ulong ticket) {m_takeprofit_ticket=ticket;}
   ulong             TakeProfitTicket(void) const {return m_takeprofit_ticket;}
   void              Volume(const double volume) {m_volume=volume;}
   double            Volume(void) const {return m_volume;}
   //--- hiding and showing of stop lines
   virtual void      Show(bool show=true);
   //--- checking   
   virtual void      Check(double &volume) {}
   virtual void      CheckInit(void);
   virtual void      CheckDeinit(void);
   virtual bool      Close(void);
   virtual bool      CheckTrailing(void);
   virtual bool      DeleteChartObject(const string);
   virtual bool      DeleteEntry(void);
   virtual bool      DeleteStopLines(void);
   virtual bool      DeleteStopLoss(void);
   virtual bool      DeleteTakeProfit(void);
   virtual bool      IsClosed(void);
   virtual bool      Update(void);
   //--- deinitialization 
   virtual bool      Deinit(void);
   //--- recovery
   virtual bool      Save(const int);
   virtual bool      Load(const int);
protected:
   virtual bool      IsStopLossValid(const double) const;
   virtual bool      IsTakeProfitValid(const double) const;
   virtual bool      Modify(const double,const double);
   virtual bool      ModifyStops(const double,const double) {return true;}
   virtual bool      ModifyStopLoss(const double) {return true;}
   virtual bool      ModifyTakeProfit(const double) {return true;}
   virtual bool      UpdateOrderStop(const double,const double) {return true;}
   //--- objects
   virtual void      MoveStopLoss(const double);
   virtual void      MoveTakeProfit(const double);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopBase::COrderStopBase(void) : m_active(true),
                                       m_volume(0.0),                                    
                                       m_stoploss_ticket(0),
                                       m_takeprofit_ticket(0),
                                       m_stoploss_closed(false),
                                       m_takeprofit_closed(false),
                                       m_closed(false),
                                       m_stop_type(0),
                                       m_stop_name("")
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopBase::~COrderStopBase(void)
  {
   Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopBase::Init(COrder *order,CStop *stop,COrderStops *order_stops)
  {
   if(stop==NULL || order==NULL) return;
   if(!stop.Active()) return;
   SetContainer(m_order_stops);
   m_stop_name=stop.Name();
   m_order=order;
   m_stop=stop;
   m_volume=m_stop.Volume();   
   m_stop.Refresh(order.Symbol());
   double stoploss=m_stop.StopLossPrice(order,GetPointer(this));
   double takeprofit=m_stop.TakeProfitPrice(order,GetPointer(this));
   m_objsl=m_stop.CreateStopLossObject(0,StopLossName(),0,stoploss);
   m_stoploss.Add(stoploss);
   m_objtp=m_stop.CreateTakeProfitObject(0,TakeProfitName(),0,takeprofit);
   m_takeprofit.Add(takeprofit);
   m_objentry=m_stop.CreateEntryObject(0,EntryName(),0,order.Price());
   if(stop.Main())
      order.MainStop(GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::Deinit(void)
  {
   if (m_objentry!=NULL)
      delete m_objentry;
   if (m_objsl!=NULL)
      delete m_objentry;
   if (m_objtp!=NULL)
      delete m_objentry;      
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::IsStopLossValid(const double stoploss) const
  {
   return (stoploss>0 && ((m_order.OrderType()==ORDER_TYPE_BUY && stoploss>StopLoss()) || (m_order.OrderType()==ORDER_TYPE_SELL && stoploss<StopLoss())));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::IsTakeProfitValid(const double takeprofit) const
  {
   return (takeprofit>0 && ((m_order.OrderType()==ORDER_TYPE_BUY && takeprofit<TakeProfit()) || (m_order.OrderType()==ORDER_TYPE_SELL && takeprofit>TakeProfit())));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::CheckTrailing(void)
  {
   if(m_stop==NULL || m_order.IsClosed() || m_order.IsSuspended() || (m_stoploss_closed && m_takeprofit_closed))
      return false;
   bool result=false;
   int action=-1;
   double stoploss=0,takeprofit=0;
   if(!m_stoploss_closed) stoploss=m_stop.CheckTrailing(m_order.Symbol(),m_order.OrderType(),m_order.Price(),StopLoss(),TRAIL_TARGET_STOPLOSS);
   if(!m_takeprofit_closed)takeprofit=m_stop.CheckTrailing(m_order.Symbol(),m_order.OrderType(),m_order.Price(),TakeProfit(),TRAIL_TARGET_TAKEPROFIT);
   if(!IsStopLossValid(stoploss))
      stoploss=0;
   if(!IsTakeProfitValid(takeprofit))
      takeprofit=0;
   if(stoploss>0 && takeprofit>0)
      action=0;
   else if(stoploss>0 && takeprofit==0)
      action=1;
   else if(takeprofit>0 && stoploss==0)
      action=2;
   if(action!=-1)
      result=Modify(stoploss,takeprofit);
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::Close(void)
  {
   bool res1=false,res2=false,result=false;
   if(m_stoploss_closed || StopLoss()==0 || m_stoploss_ticket==0)
      res1=true;
   else if(m_stoploss_ticket>0 && !m_stoploss_closed)
     {
      if(m_stop.DeleteStopOrder(m_stoploss_ticket))
         res1=DeleteStopLoss();
     }
   if(m_takeprofit_closed || TakeProfit()==0 || m_takeprofit_ticket==0)
      res2=true;
   else if(m_takeprofit_ticket>0 && !m_takeprofit_closed)
     {
      if(m_stop.DeleteStopOrder(m_takeprofit_ticket))
         res2=DeleteTakeProfit();
     }
   if(res1 && res2)
      result=DeleteEntry() && DeleteStopLoss() && DeleteTakeProfit();
   if(result)
      m_closed=true;
//CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_STOP_CLOSE,GetPointer(this));
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::IsClosed(void)
  {
   if(m_closed)
      return true;
   if(m_objentry!=NULL && !m_objentry.ChartObjectExists())
      m_closed=true;
   if(m_stoploss_closed && m_takeprofit_closed)
      m_closed=true;
   if(m_closed)
      Close();
   return m_closed;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::Update(void)
  {
   if(m_stop==NULL) return true;
   if(m_order.IsClosed() || m_order.IsSuspended()) return false;
   double stoploss=0.0,takeprofit=0.0;
   bool result=false;
   bool dragged=false;
   if(CheckPointer(m_objtp)==POINTER_DYNAMIC)
     {
      double tp_line=m_objtp.GetPrice();
      if(tp_line!=TakeProfit())
        {
         if(m_stop.Pending() || m_stop.Broker())
           {
            Sleep(m_stop.Delay());
            dragged=true;
           }
        }
     }
   if(CheckPointer(m_objsl)==POINTER_DYNAMIC)
     {
      double sl_line=m_objsl.GetPrice();
      if(sl_line!=StopLoss())
        {
         if(m_stop.Pending() || m_stop.Broker())
           {
            Sleep(m_stop.Delay());
            dragged=true;
           }
        }
     }
   if(dragged)
     {
      if(CheckPointer(m_objtp)==POINTER_DYNAMIC)
         takeprofit=m_objtp.GetPrice();
      if(CheckPointer(m_objsl)==POINTER_DYNAMIC)
         stoploss=m_objsl.GetPrice();
      result=UpdateOrderStop(stoploss,takeprofit);
     }
//if(result)
//CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_STOP_UPDATE_DONE,GetPointer(this));
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopBase::CheckInit()
  {
//CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_STOP_CHECK,GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopBase::CheckDeinit()
  {
//CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_STOP_CHECK_DONE,GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::DeleteChartObject(string name)
  {
   return ObjectDelete(0,name);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::DeleteStopLoss(void)
  {
   if(CheckPointer(m_objsl)==POINTER_DYNAMIC)
     {
      m_objsl.Delete();
      delete m_objsl;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::DeleteTakeProfit(void)
  {
   if(CheckPointer(m_objtp)==POINTER_DYNAMIC)
     {
      m_objtp.Delete();
      delete m_objtp;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::DeleteEntry(void)
  {
   if(CheckPointer(m_objentry)==POINTER_DYNAMIC)
     {
      m_objentry.Delete();
      delete m_objentry;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::DeleteStopLines(void)
  {
   if(DeleteStopLoss() && DeleteTakeProfit())
      return DeleteEntry();
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopBase::MoveStopLoss(const double stoploss)
  {
   if(CheckPointer(m_objsl)==POINTER_DYNAMIC)
      if(m_objsl.Move(stoploss))
         StopLoss(stoploss);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void COrderStopBase::MoveTakeProfit(const double takeprofit)
  {
   if(CheckPointer(m_objtp)==POINTER_DYNAMIC)
      if(m_objtp.Move(takeprofit))
         TakeProfit(takeprofit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::Modify(const double stoploss,const double takeprofit)
  {
   bool stoploss_modified=false,takeprofit_modified=false;
   double oldsl=StopLoss(),oldtp=TakeProfit();
   if(stoploss>0 && takeprofit>0)
     {
      //CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_MODIFY,GetPointer(this));
      if(ModifyStops(stoploss,takeprofit))
        {
         stoploss_modified=true;
         takeprofit_modified=true;
         //CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_MODIFY_DONE,GetPointer(this));
        }
      //else CreateEvent(EVENT_CLASS_ERROR,ACTION_ORDER_MODIFY,GetPointer(this));
     }
   else if(stoploss>0 && takeprofit==0)
     {
      //CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_SL_MODIFY,GetPointer(this));
      stoploss_modified=ModifyStopLoss(stoploss);
      //if(stoploss_modified)
      //CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_SL_MODIFY_DONE,GetPointer(this));
      //else CreateEvent(EVENT_CLASS_ERROR,ACTION_ORDER_SL_MODIFY,GetPointer(this));
     }
   else if(takeprofit>0 && stoploss==0)
     {
      //CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_TP_MODIFY,GetPointer(this));
      takeprofit_modified=ModifyTakeProfit(takeprofit);
      //if(takeprofit_modified)
      //CreateEvent(EVENT_CLASS_STANDARD,ACTION_ORDER_TP_MODIFY_DONE,GetPointer(this));
      //else CreateEvent(EVENT_CLASS_ERROR,ACTION_ORDER_TP_MODIFY,GetPointer(this));
     }
   return stoploss_modified || takeprofit_modified;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
COrderStopBase::Show(bool show=true)
  {
   int setting=show?OBJ_ALL_PERIODS:OBJ_NO_PERIODS;
   if(CheckPointer(m_objentry)) m_objentry.Timeframes(setting);
   if(CheckPointer(m_objsl))     m_objsl.Timeframes(setting);
   if(CheckPointer(m_objtp))     m_objtp.Timeframes(setting);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::Save(const int handle)
  {
//ADT::WriteDouble(handle,m_volume);
//ADT::WriteDouble(handle,m_volume_fixed);
//ADT::WriteDouble(handle,m_volume_percent);
//ADT::WriteObject(handle,GetPointer(m_stoploss));
//ADT::WriteObject(handle,GetPointer(m_takeprofit));
//ADT::WriteLong(handle,m_stoploss_ticket);
//ADT::WriteLong(handle,m_takeprofit_ticket);
//ADT::WriteBool(handle,m_stoploss_closed);
//ADT::WriteBool(handle,m_takeprofit_closed);
//ADT::WriteInteger(handle,m_stop_type);
//ADT::WriteString(handle,m_stop_name);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool COrderStopBase::Load(const int handle)
  {
//int temp;
//ADT::ReadDouble(handle,m_volume);
//ADT::ReadDouble(handle,m_volume_fixed);
//ADT::ReadDouble(handle,m_volume_percent);
//ADT::ReadObject(handle,GetPointer(m_stoploss));
//ADT::ReadObject(handle,GetPointer(m_takeprofit));
//ADT::ReadLong(handle,m_stoploss_ticket);
//ADT::ReadLong(handle,m_takeprofit_ticket);
//ADT::ReadBool(handle,m_stoploss_closed);
//ADT::ReadBool(handle,m_takeprofit_closed);
//ADT::ReadInteger(handle,temp);
//m_stop_type=(ENUM_STOP_TYPE) temp;
//ADT::ReadString(handle,m_stop_name);
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Order\OrderStop.mqh"
#else
#include "..\..\MQL4\Order\OrderStop.mqh"
#endif
//+------------------------------------------------------------------+
