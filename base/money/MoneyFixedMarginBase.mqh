//+------------------------------------------------------------------+
//|                                             MoneyFixedMargin.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include "MoneyBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JMoneyFixedMarginBase : public JMoney
  {
public:
   virtual void      UpdateLotSize(double price,ENUM_ORDER_TYPE type,double sl);
                     JMoneyFixedMarginBase();
                    ~JMoneyFixedMarginBase();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JMoneyFixedMarginBase::JMoneyFixedMarginBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JMoneyFixedMarginBase::~JMoneyFixedMarginBase()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JMoneyFixedMarginBase::UpdateLotSize(double price,ENUM_ORDER_TYPE type,double sl)
  {
   if(m_symbol==NULL)
      return;
   if(price==0.0)
     {
      if(type==ORDER_TYPE_BUY)
         m_volume=m_account.MaxLotCheck(m_symbol.Name(),type,m_symbol.Ask(),m_percent);
      else if(type==ORDER_TYPE_SELL)
         m_volume=m_account.MaxLotCheck(m_symbol.Name(),type,m_symbol.Bid(),m_percent);
     }
   else
      m_volume=m_account.MaxLotCheck(m_symbol.Name(),type,price,m_percent);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\money\MoneyFixedMargin.mqh"
#else
#include "..\..\mql4\money\MoneyFixedMargin.mqh"
#endif
//+------------------------------------------------------------------+