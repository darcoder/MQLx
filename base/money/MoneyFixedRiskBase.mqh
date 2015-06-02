//+------------------------------------------------------------------+
//|                                           MoneyFixedRiskBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include "MoneyBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JMoneyFixedRiskBase : public JMoney
  {
public:
                     JMoneyFixedRiskBase(void);
                    ~JMoneyFixedRiskBase(void);
   virtual void      UpdateLotSize(const double price,const ENUM_ORDER_TYPE type,const double sl);
   virtual bool      Validate(void) const;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JMoneyFixedRiskBase::JMoneyFixedRiskBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JMoneyFixedRiskBase::~JMoneyFixedRiskBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JMoneyFixedRiskBase::Validate(void) const 
  {
   if (m_percent<=0)
   {
      PrintFormat(__FUNCTION__+": invalid percentage: "+(string)m_percent);
      return(false);
   }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JMoneyFixedRiskBase::UpdateLotSize(const double price,const ENUM_ORDER_TYPE type,const double sl)
  {
   if(m_symbol==NULL) return;
   double minvol=m_symbol.LotsMin();
   double balance=m_equity==false?m_account.Balance():m_account.Equity();   
   if(sl==0.0)
   {
      m_volume=minvol;
   }   
   else
     {
      double loss=0;
      if(price==0.0)
        {
         if(type==ORDER_TYPE_BUY)
         {
            loss=-m_account.OrderProfitCheck(m_symbol.Name(),type,1.0,m_symbol.Ask(),sl);
         }   
         else if(type==ORDER_TYPE_SELL)
         {
            loss=-m_account.OrderProfitCheck(m_symbol.Name(),type,1.0,m_symbol.Bid(),sl);
         }   
        }
      else
      {
         loss=-m_account.OrderProfitCheck(m_symbol.Name(),type,1.0,price,sl);
      }            
      double stepvol=m_symbol.LotsStep();
      m_volume=MathFloor(m_account.Balance()*m_percent/loss/100.0/stepvol)*stepvol;
      Print("calculated volume: "+m_volume+" loss: "+loss+" sl: "+sl+" percent: "+m_percent);
     }
   
   if(m_volume<minvol)
      m_volume=minvol;
   double maxvol=m_symbol.LotsMax();
   if(m_volume>maxvol)
      m_volume=maxvol;
   m_last_update=TimeCurrent();
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\money\MoneyFixedRisk.mqh"
#else
#include "..\..\mql4\money\MoneyFixedRisk.mqh"
#endif
//+------------------------------------------------------------------+
