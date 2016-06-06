//+------------------------------------------------------------------+
//|                                                 StopLineBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <ChartObjects\ChartObjectsLines.mqh>
#include <Files\FileBin.mqh>
class CStop;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CStopLineBase : public CChartObjectHLine
  {
protected:
   CStop            *m_stop;
public:
                     CStopLineBase(void);
                    ~CStopLineBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_STOPLINE;}
   virtual void      SetContainer(CStop *stop){m_stop=stop;}
   virtual double    GetPrice(const int point=0);
   virtual bool      Move(const double price);
   virtual bool      SetStyle(const ENUM_LINE_STYLE style);
   virtual bool      SetColor(const color clr);   
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopLineBase::CStopLineBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStopLineBase::~CStopLineBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopLineBase::Move(const double price)
  {
   return ObjectSetDouble(0,m_name,OBJPROP_PRICE,0,price);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStopLineBase::GetPrice(const int point=0)
  {
   return ObjectGetDouble(0,m_name,OBJPROP_PRICE,point);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopLineBase::SetColor(const color clr)
  {
   return ObjectSetInteger(0,m_name,OBJPROP_COLOR,clr);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStopLineBase::SetStyle(const ENUM_LINE_STYLE style)
  {
   return ObjectSetInteger(0,m_name,OBJPROP_STYLE,style);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Stop\StopLine.mqh"
#else
#include "..\..\MQL4\Stop\StopLine.mqh"
#endif
//+------------------------------------------------------------------+
