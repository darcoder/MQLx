//+------------------------------------------------------------------+
//|                                                    TimesBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Arrays\ArrayObj.mqh>
#include <Files\FileBin.mqh>
#include "TimeFilterBase.mqh"
#include "TimeRangeBase.mqh"
#include "TimerBase.mqh"
class CExpert;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTimesBase : public CArrayObj
  {
protected:
   bool              m_activate;
   int               m_selected;
   CExpert        *m_strategy;
public:
                     CTimesBase(void);
                    ~CTimesBase(void);
   virtual int       Type(void) const {return CLASS_TYPE_TIMES;}
   //-- initialization
   virtual bool      Init(CExpert *s);
   virtual void      SetContainer(CExpert *s){m_strategy=s;}
   virtual bool      Validate(void) const;
   //--- activation and deactivation
   bool              Active(void) const {return m_activate;}
   void              Active(const bool activate) {m_activate=activate;}
   int               Selected() {return m_selected;}
   //--- checking
   virtual bool      Evaluate(void) const;
   //--- recovery
   virtual bool      CreateElement(const int index);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimesBase::CTimesBase(void) : m_activate(true),
                               m_selected(-1)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimesBase::~CTimesBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimesBase::Init(CExpert *s)
  {
   for(int i=0;i<Total();i++)
     {
      CTime *time=At(i);
      time.Init(s,GetPointer(this));
     }
   SetContainer(s);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimesBase::Validate(void) const
  {
   for(int i=0;i<Total();i++)
     {
      CTime *time=At(i);
      if(!time.Validate())
         return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimesBase::Evaluate(void) const
  {
   if(!Active()) return true;
   for(int i=0;i<Total();i++)
     {
      CTime *time=At(i);
      if(CheckPointer(time))
         if(!time.Evaluate()) return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTimesBase::CreateElement(const int index)
  {
   CTime*time=new CTime();
   time.SetContainer(GetPointer(this));
   return Insert(GetPointer(time),index);
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\time\Times.mqh"
#else
#include "..\..\mql4\time\Times.mqh"
#endif
//+------------------------------------------------------------------+
