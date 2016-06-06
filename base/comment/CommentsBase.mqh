//+------------------------------------------------------------------+
//|                                                 CommentsBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include <Arrays\List.mqh>
#include "CommentBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CCommentsBase : public CList
  {
protected:
   bool              m_activate;
public:
                     CCommentsBase(void);
                    ~CCommentsBase(void);
   bool              Active(){return m_activate;}
   void              Active(bool active){m_activate = active;}
   virtual void      Display(void);
   virtual void      Concatenate(string &str,string comment);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCommentsBase::CCommentsBase(void) : m_activate(true)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCommentsBase::~CCommentsBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCommentsBase::Display(void)
  {
   Comment("");
   string str="";
   CComment *comment=GetFirstNode();
   while(CheckPointer(comment)==POINTER_DYNAMIC)
     {
      Concatenate(str,comment.Text());
      comment=GetNextNode();
     }
   Comment(str);
   Clear();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CCommentsBase::Concatenate(string &str,string comment)
  {
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Comment\Comments.mqh"
#else
#include "..\..\MQL4\Comment\Comments.mqh"
#endif
//+------------------------------------------------------------------+
