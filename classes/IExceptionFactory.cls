/*** Interface 
/*** @Author: Harika Sai P And Divija Deepthi
/*** Created Date: 20 MAR 2019
/*** Purpose: This is an interface used for handling Exceptions as part of the framework.
/*** JIRA : DLT-15694 Create Global Data Layer - All our Sobjects operation should go with this layer */
/*** Change History  ******************************************************************************************************/
/*** Modified By    Modified Date    JIRA    
/**************************************************************************************************************************/

public interface IExceptionFactory{
   
   void logDatabaseException(ExceptionFactory.ExceptionWrapper  exWrap); // method signature only
   void logException(ExceptionFactory.ExceptionWrapper  exWrap);
   void logExceptions(List<ExceptionFactory.ExceptionWrapper> exWrap);
   
}