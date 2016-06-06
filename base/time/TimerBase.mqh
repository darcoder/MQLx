//+------------------------------------------------------------------+
//|                                                    TimerBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#define YEAR_SECONDS 31536000
#define MONTH_SECONDS 2419200
#define DAY_SECONDS 86400
#define HOUR_SECONDS 3600
#define MINUTE_SECONDS 60
#include "TimeBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTimerBase : public CTime
  {
protected:
   uint              m_years;
   uint              m_months;
   uint              m_days;
   uint              m_hours;
   uint              m_minutes;
   uint              m_seconds;
   int               m_total;
   int               m_elapsed;
public:
                     CTimerBase(void);
                    ~CTimerBase(void);
   //--- initialization
   virtual bool      Init(const uint years,const uint months,const uint days,const uint hours,const uint minutes,const uint seconds);
   virtual bool      Validate(void);
   //--- getters and setters
   uint              Year(void) const {return m_years;}
   void              Year(const uint years) {m_years=years;}
   uint              Month(void) const {return m_months;}
   void              Month(const uint months) {m_months=months;}
   uint              Days(void) const {return m_days;}
   void              Days(const uint days) {m_days=days;}
   uint              Hours(void) const {return m_hours;}
   void              Hours(const uint hours) {m_hours=hours;}
   uint              Minutes(void) const {return m_minutes;}
   void              Minutes(const uint minutes) {m_minutes=minutes;}
   uint              Seconds(void) const {return m_seconds;}
   void              Seconds(const uint seconds) {m_seconds=seconds;}
   bool              Total(void) const {return m_total;}
   //--- processing   
   virtual bool      Elapsed(void) const {return m_elapsed;}
   virtual bool      Evaluate(void);
   virtual void      RecalculateTotal(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimerBase::CTimerBase(void) : m_years(0),
                               m_months(0),
                               m_days(0),
                               m_hours(0),
                               m_minutes(0),
                               m_seconds(0),
                               m_total(0)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimerBase::~CTimerBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimerBase::Init(const uint years,const uint months,const uint days,const uint hours,const uint minutes,const uint seconds)
  {
   m_years=years;
   m_months=months;
   m_days=days;
   m_hours=hours;
   m_minutes=minutes;
   m_seconds=seconds;
   RecalculateTotal();
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimerBase::Validate(void)
  {
   if(m_total<=0)
     {
      PrintFormat("Invalid time setting for timer");
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CTimerBase::RecalculateTotal(void)
  {
   m_total=(int)((m_years*YEAR_SECONDS)+(m_months*MONTH_SECONDS)+(m_days*DAY_SECONDS)+(m_hours*HOUR_SECONDS)+(m_minutes*MINUTE_SECONDS));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimerBase::Evaluate(void)
  {
   if(!Active()) return true;
   bool result=true;
   m_elapsed=(int)(TimeCurrent()-m_time_start);
   if(m_elapsed>=m_total) result=false;
   return Reverse()?result:!result;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Time\Timer.mqh"
#else
#include "..\..\MQL4\Time\Timer.mqh"
#endif
//+------------------------------------------------------------------+
