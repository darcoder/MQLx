//+------------------------------------------------------------------+
//|                                                 StrategyBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "..\..\common\enum\ENUM_CLASS_TYPE.mqh"
#include "..\..\common\class\ADT.mqh"
#include <Object.mqh>
#include <Arrays\ArrayInt.mqh>
#include <Files\FileBin.mqh>
#include "..\lib\AccountInfo.mqh"
#include "..\symbol\SymbolManagerBase.mqh"
#include "..\candle\CandleBase.mqh"
#include "..\signal\SignalsBase.mqh"
#include "..\trade\TradeBase.mqh"
#include "..\order\OrdersBase.mqh"
#include "..\stop\StopsBase.mqh"
#include "..\money\MoneysBase.mqh"
#include "..\time\TimesBase.mqh"
#include "..\comment\CommentsBase.mqh"
#include "..\ordermanager\OrderManagerBase.mqh"
#include "..\candle\CandleManagerBase.mqh"
class CExperts;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CStrategyBase : public CObject
  {
protected:
   //--- trade parameters
   bool              m_activate;
   string            m_name;
   //--- signal parameters
   bool              m_every_tick;
   bool              m_one_trade_per_candle;
   string            m_symbol_name;
   int               m_period;
   bool              m_position_reverse;
   bool              m_offline_mode;
   int               m_offline_mode_delay;
   //--- signal objects
   CSignals         *m_signals;
   //--- trade objects   
   CAccountInfo     *m_account;
   CSymbolManager    m_symbol_man;
   COrderManager     m_order_man;
   //--- trading time objects
   CTimes           *m_times;
   //--- comments
   CComments        *m_comments;
   //--- candle
   CCandleManager    m_candle_man;
   //--- container
   CExperts          *m_expert;
public:
                     CStrategyBase(void);
                    ~CStrategyBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_STRATEGY;}
   //--- initialization
   virtual bool      Add(CObject*);
   virtual bool      AddMoneys(CMoneys*);
   virtual bool      AddSignals(CSignals*);
   virtual bool      AddStops(CStops*);
   virtual bool      AddTimes(CTimes*);
   virtual bool      Init(string symbol,int timeframe,int magic,bool every_tick=true,bool one_trade_per_candle=true,bool position_reverse=true);
   virtual bool      InitAccount(CAccountInfo*);
   virtual bool      InitTrade(CExpertTrade *trade=NULL){return m_order_man.InitTrade(GetPointer(trade));}
   virtual bool      InitComponents(void);
   virtual bool      InitSignals(void);
   virtual bool      InitTimes(void);
   virtual bool      InitOrderManager() {return m_order_man.Init(GetPointer(this),GetPointer(m_symbol_man),GetPointer(m_account));}
   virtual bool      Validate(void) const;
   //--- container
   virtual CExperts  *GetContainer() const {return GetPointer(m_expert);}
   virtual void      SetContainer(CExperts *e){m_expert=e;}
   //--- activation and deactivation
   virtual bool      Active(void) const {return m_activate;}
   virtual void      Active(const bool activate) {m_activate=activate;}
   //--- setters and getters       
   string            Name() const {return m_name;}
   void              Name(const string name) {m_name = name;}
   bool              OfflineMode(void) const {return m_offline_mode;}
   void              OfflineMode(const bool mode) {m_offline_mode=mode;}
   int               OfflineModeDelay() const {return m_offline_mode_delay;}
   void              OfflineModeDelay(const int delay){m_offline_mode_delay=delay;}
   //--- object pointers
   CAccountInfo      *AccountInfo(void) const {return GetPointer(m_account);}
   CComments         *Comments() const {return GetPointer(m_comments);}
   CStop             *MainStop(void) const {return m_order_man.MainStop();}
   CMoneys           *Moneys(void) const {return m_order_man.Moneys();}
   COrders           *Orders() {return m_order_man.Orders();}
   COrders           *OrdersHistory() {return m_order_man.OrdersHistory();}
   CArrayInt         *OtherMagic() {return m_order_man.OtherMagic();}
   CStops            *Stops(void) const {return m_order_man.Stops();}
   CSignals          *Signals(void) const {return GetPointer(m_signals);}
   //CSymbolInfo       *SymbolInfo(void) const {return GetPointer(m_symbol);}
   CTimes            *Times(void) const {return GetPointer(m_times);}
   //--- chart comment manager
   void              AddComment(const string);
   void              ChartComment(CComments *comments) {m_comments=comments;}
   void              DisplayComment();
   //--- order manager
   virtual bool      AddOtherMagic(const int magic) {return m_order_man.AddOtherMagic(magic);}
   virtual void      AddOtherMagicString(const string &magics[]){m_order_man.AddOtherMagicString(magics);}
   void              AsyncMode(const bool async) {m_order_man.AsyncMode(async);}
   string            Comment(void) const {return m_order_man.Comment();}
   void              Comment(const string comment){m_order_man.Comment(comment);}
   bool              EnableTrade(void) const {return m_order_man.EnableTrade();}
   void              EnableTrade(bool allowed){m_order_man.EnableTrade(allowed);}
   bool              EnableLong(void) const {return m_order_man.EnableLong();}
   void              EnableLong(bool allowed){m_order_man.EnableLong(allowed);}
   bool              EnableShort(void) const {return m_order_man.EnableShort();}
   void              EnableShort(bool allowed){m_order_man.EnableShort(allowed);}
   int               Expiration(void) const {return m_order_man.Expiration();}
   void              Expiration(const int expiration) {m_order_man.Expiration(expiration);}
   double            LotSize(void) const {return m_order_man.LotSize();}
   void              LotSize(const double lotsize){m_order_man.LotSize(lotsize);}
   int               MaxOrdersHistory(void) const {return m_order_man.MaxOrdersHistory();}
   void              MaxOrdersHistory(const int max) {m_order_man.MaxOrdersHistory(max);}
   int               Magic(void) const {return m_order_man.Magic();}
   void              Magic(const int magic) {m_order_man.Magic(magic);}
   virtual uint      MaxTrades(void) const {return m_order_man.MaxTrades();}
   virtual void      MaxTrades(const int max_trades){m_order_man.MaxTrades(max_trades);}
   virtual int       MaxOrders(void) const {return m_order_man.MaxOrders();}
   virtual void      MaxOrders(const int max_orders) {m_order_man.MaxOrders(max_orders);}
   int               OrdersTotal(void) const {return m_order_man.OrdersTotal();}
   int               OrdersHistoryTotal(void) const {return m_order_man.OrdersHistoryTotal();}
   int               TradesTotal(void) const{return m_order_man.TradesTotal();}
   //--- signal manager   
   virtual int       Period(void) const {return m_period;}
   virtual void      Period(const int period) {m_period=period;}
   virtual bool      EveryTick(void) const {return m_every_tick;}
   virtual void      EveryTick(const bool every_tick) {m_every_tick=every_tick;}
   virtual bool      OneTradePerCandle(void) const {return m_one_trade_per_candle;}
   virtual void      OneTradePerCandle(const bool one_trade_per_candle){m_one_trade_per_candle=one_trade_per_candle;}
   virtual bool      PositionReverse(void) const {return m_position_reverse;}
   virtual void      PositionReverse(const bool position_reverse){m_position_reverse=position_reverse;}
   //--- additional candles
   virtual void      AddCandle(const string,const int);
   //--- new bar detection
   virtual void      DetectNewBars(void);
   //-- generic events
   virtual bool      OnTick(void);
   virtual void      OnChartEvent(const int,const long&,const double&,const string&);
   //--- recovery
   virtual bool      Save(const int);
   virtual bool      Load(const int);
protected:
   //--- candle manager   
   virtual bool      IsNewBar(string symbol,int period);
   //--- order manager
   virtual void      CloseOppositeOrders(const int entry,const int exit) {m_order_man.CloseOppositeOrders(entry,exit);}
   virtual void      ManageOrders(void) {m_order_man.ManageOrders();}
   virtual void      ManageOrdersHistory(void){m_order_man.ManageOrdersHistory();}
   virtual void      OnTradeTransaction(COrder*) {}
   virtual bool      TradeOpen(const string symbol,const int res) {return m_order_man.TradeOpen(symbol,res);}
   //--- signal manager
   virtual bool      CheckSignals(int&,int&) const;
   //--- symbol manager
   virtual bool      RefreshRates(void);
   //--- deinitialization
   void              Deinit(const int);
   void              DeinitAccount(void);
   void              DeinitComments(void);
   void              DeinitSignals(void);
   void              DeinitSymbol(void);
   void              DeinitTimes(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStrategyBase::CStrategyBase(void) : m_activate(true),
                                     m_every_tick(true),
                                     m_one_trade_per_candle(true),
                                     m_period(PERIOD_CURRENT),
                                     m_position_reverse(true),
                                     m_offline_mode(false),
                                     m_offline_mode_delay(500)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStrategyBase::~CStrategyBase(void)
  {
   Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStrategyBase::Init(string symbol,int period,int magic,bool every_tick=true,bool one_trade_per_candle=true,bool position_reverse=true)
  {
   CSymbolInfo *instrument;
   if((instrument=new CSymbolInfo)==NULL)
      return false;
   if(symbol==NULL) symbol=Symbol();
   if(!instrument.Name(symbol))
      return false;
   instrument.Refresh();
   m_symbol_man.Add(instrument);
   m_period=period;
   m_every_tick=every_tick;
   m_order_man.Magic(magic);
   m_position_reverse=position_reverse;
   m_one_trade_per_candle=one_trade_per_candle;
   m_order_man.InitTrade();
   CCandle *candle=new CCandle();
   candle.Init(instrument,m_period);
   m_candle_man.Add(candle);
   Magic(magic);

   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStrategyBase::InitComponents(void)
  {
   bool result=InitSignals() && InitAccount() && InitTimes()
               && InitOrderManager();
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStrategyBase::InitSignals(void)
  {
   if(m_signals==NULL) return true;
   return m_signals.Init(GetPointer(this),GetPointer(m_comments));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStrategyBase::InitTimes(void)
  {
   if(m_times==NULL) return true;
   return m_times.Init(GetPointer(this));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStrategyBase::InitAccount(CAccountInfo *account=NULL)
  {
   if(m_account!=NULL)
      delete m_account;
   if(account==NULL)
     {
      if((m_account=new CAccountInfo)==NULL)
         return false;
     }
   else m_account=account;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStrategyBase::AddComment(const string comment)
  {
   if(CheckPointer(m_comments)==POINTER_DYNAMIC)
      m_comments.Add(new CComment(comment));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStrategyBase::DisplayComment()
  {
   if(CheckPointer(m_comments)==POINTER_DYNAMIC)
      m_comments.Display();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStrategyBase::Add(CObject *object)
  {
   bool result=false;
   switch(object.Type())
     {
      case CLASS_TYPE_SIGNALS:   result=AddSignals(object); break;
      case CLASS_TYPE_MONEYS:    result=AddMoneys(object);  break;
      case CLASS_TYPE_STOPS:     result=AddStops(object);   break;
      case CLASS_TYPE_TIMES:     result=AddTimes(object);   break;
      default: PrintFormat(__FUNCTION__+": unknown object: "+DoubleToString(object.Type(),0));
     }
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStrategyBase::AddSignals(CSignals *signals)
  {
   if(CheckPointer(signals)==POINTER_DYNAMIC)
     {
      m_signals=signals;
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStrategyBase::AddMoneys(CMoneys *moneys)
  {
   return m_order_man.AddMoneys(GetPointer(moneys));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStrategyBase::AddStops(CStops *stops)
  {
   m_order_man.AddStops(GetPointer(stops));
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStrategyBase::AddTimes(CTimes *times)
  {
   if(CheckPointer(times)==POINTER_DYNAMIC)
     {
      m_times=times;
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStrategyBase::AddCandle(const string symbol,const int timeframe)
  {
   CSymbolInfo *instrument=new CSymbolInfo();
   instrument.Name(symbol);
   instrument.Refresh();
   CCandle *candle=new CCandle();
   candle.Init(instrument,timeframe);
   m_candle_man.Add(candle);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStrategyBase::Validate(void) const
  {
   if(CheckPointer(m_signals)==POINTER_DYNAMIC)
     {
      if(!m_signals.Validate())
         return false;
     }
   if(CheckPointer(m_times)==POINTER_DYNAMIC)
     {
      if(!m_times.Validate())
         return false;
     }
   return m_order_man.Validate();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStrategyBase::OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStrategyBase::OnTick(void)
  {
   if(!Active()) return false;
   if(!RefreshRates()) return false;
   bool ret=false;
//bool newtick= m_tick.IsNewTick(m_symbol);
   bool newtick=true;
   DetectNewBars();
   bool newbar=IsNewBar(m_symbol_name,m_period);
   m_order_man.OnTick();
   ManageOrders();
   int entry=0,exit=0;
   CheckSignals(entry,exit);
//AddComment("last tick: "+TimeToStr(TimeCurrent(),TIME_DATE|TIME_MINUTES|TIME_SECONDS));
   AddComment("entry signal: "+EnumToString((ENUM_CMD)entry));
   AddComment("exit signal: "+EnumToString((ENUM_CMD)exit));
   if(newbar || (m_every_tick && newtick))
     {
      CloseOppositeOrders(entry,exit);
      ManageOrders();
      if(!m_candle_man.TradeProcessed(m_symbol_name,m_period))
        {
         if(!CheckPointer(m_times) || (m_times.Evaluate()))
            ret=TradeOpen(m_symbol_name,entry);
         if(ret)
           {
            //m_last_trade_data=m_tick.LastTick();
            m_candle_man.TradeProcessed(m_symbol_name,m_period,true);
           }
        }
     }
   ManageOrdersHistory();
   DisplayComment();
   return ret;
/*
   for (int i=0;i<m_instance_man.Total();i++)
   {  
      CExpertInstance *instance = m_instance_man.At(i);
      Process(instance);
   }
   */
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStrategyBase::DetectNewBars(void)
  {
   m_candle_man.Check();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStrategyBase::CheckSignals(int &entry,int &exit) const
  {
   if(CheckPointer(m_signals)==POINTER_DYNAMIC)
      return m_signals.CheckSignals(entry,exit);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStrategyBase::RefreshRates()
  {
   return m_symbol_man.RefreshRates();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStrategyBase::IsNewBar(const string symbol,const int period)
  {
   return m_candle_man.IsNewCandle(symbol,period);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStrategyBase::Deinit(const int reason=0)
  {
   DeinitSymbol();
   DeinitSignals();
   DeinitAccount();
   DeinitComments();
   DeinitTimes();

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStrategyBase::DeinitSignals(void)
  {
   ADT::Delete(m_signals);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStrategyBase::DeinitSymbol(void)
  {
//ADT::Delete(m_symbol);
//ADT::Delete(m_symbol_man);
   m_symbol_man.Deinit();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStrategyBase::DeinitAccount(void)
  {
   ADT::Delete(m_account);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStrategyBase::DeinitComments(void)
  {
   ADT::Delete(m_comments);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStrategyBase::DeinitTimes(void)
  {
   ADT::Delete(m_times);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStrategyBase::Save(const int handle)
  {
//ADT::WriteStruct(handle,m_last_trade_data);
//ADT::WriteObject(handle,GetPointer(m_orders));
//ADT::WriteObject(handle,GetPointer(m_orders_history));
//ADT::WriteObject(handle,GetPointer(m_tick));
//ADT::WriteObject(handle,GetPointer(m_candle));
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStrategyBase::Load(const int handle)
  {
//ADT::ReadStruct(handle,m_last_trade_data);
//ADT::ReadObject(handle,GetPointer(m_orders));
//ADT::ReadObject(handle,GetPointer(m_orders_history));
//ADT::ReadObject(handle,GetPointer(m_tick));
//ADT::ReadObject(handle,GetPointer(m_candle));
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\expert\Strategy.mqh"
#else
#include "..\..\mql4\expert\Strategy.mqh"
#endif
//+------------------------------------------------------------------+
