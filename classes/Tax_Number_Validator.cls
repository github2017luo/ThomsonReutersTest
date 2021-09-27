public with sharing class Tax_Number_Validator {

// ---------------------------------------------------- CNPJ Validator ------------------------------------------------------------

  public static boolean isValid_CNPJ(String value) {
    //system.debug(logginglevel.info, '### Validando CNPJ - Valor ' + value);
    
    if(value == null)
      value = '';
      
    String cnpj = '';
    String dv = '';
    
    try {
      // validar formato
      if(!Pattern.matches('^\\d{14}$', value)) {
       // system.debug(logginglevel.info, '>>> Formato CNPJ inválido ' + value);
        return false;
      }
      
      // All digits should not be equal
      String all_equal = '';
      for(Integer d=0; d<=9; d++) { // testing digits from 0 to 9
        all_equal = '';
        for(Integer i=0; i <14; i++) // concatenating
          all_equal += String.valueOf(d);
        //system.debug(logginglevel.info, '>>> todosIguales ' + todosIguales);
        if(value == all_equal ) {
         // system.debug(logginglevel.info, '>>> Formato CNPJ inválido ' + value);
          return false;
        }
      }
      
      cnpj = value.substring(0,12);
      dv = value.substring(12,14);
      system.debug(logginglevel.info, '>>> cnpj ' + cnpj);
      system.debug(logginglevel.info, '>>> dv ' + dv);
    } catch(Exception e) {
     // system.debug(logginglevel.error, 'ERROR de Formato CNPJ Invalido ' + value);
      return false;
    }
    
    // fill a vector with each digit of nro to validate
    Integer[] dv1_digits = new Integer[ cnpj.length() ];
    for(Integer i=0; i<dv1_digits.size();i++)
      dv1_digits[i] = Integer.valueOf(value.substring(i,i+1));
    system.debug(logginglevel.info, '>>> Digitos ' + dv1_digits);
    
    // loading a vector with the same size to load multipliers
    Integer[] dv1_multipl = new Integer[]{6,7,8,9,2,3,4,5,6,7,8,9};
    system.debug(logginglevel.info, '>>> Multiplicadores ' + dv1_multipl);
    
    // third vector with the results of the multiplications
    Integer[] dv1_results = new Integer[ dv1_digits.size() ];
    for(Integer i=0; i<dv1_digits.size();i++)
      dv1_results[i] = dv1_digits[i] * dv1_multipl[i];
    system.debug(logginglevel.info, '>>> Resultados ' + dv1_results);
    
    // summary of vector results
    Integer sum = 0;
    for(Integer v : dv1_results)
      sum += v;
    system.debug(logginglevel.info, '>>> SUM ' + sum);
      
    // MOD(sum, 11)
    Integer mod = Math.mod(sum, 11);
    system.debug(logginglevel.info, '>>> MOD ' + mod);
    
    // Validation of DV1
    Integer resDV1 = mod; 
    system.debug(logginglevel.info, '>>> DV1 ' + resDV1);
    
    //E-Values ​​(14/11/2012) added according to documentation
    if(resDV1==10)
    {
      resDV1 = 0;
    }
    
    
    // two digits of vector are added at the end the resDV1
    Integer[] dv2_digits = new Integer[ dv1_digits.size()+1 ];
    for(Integer i=0; i<dv1_digits.size();i++)
      dv2_digits[i] = dv1_digits[i];
    // add dv1 at the end
    dv2_digits[ dv2_digits.size()-1 ] = resDV1;
    system.debug(logginglevel.info, '>>> Digitos ' + dv2_digits);
    
    // loading a vector with the same size to load multipliers
    Integer[] dv2_multipl = new Integer[]{5,6,7,8,9,2,3,4,5,6,7,8,9};
    system.debug(logginglevel.info, '>>> Miltiplicadores ' + dv2_multipl);
    
    // third vector with the results of the multiplications
    Integer[] dv2_results = new Integer[ dv2_digits.size() ];
    for(Integer i=0; i<dv2_digits.size();i++)
      dv2_results[i] = dv2_digits[i] * dv2_multipl[i];
    system.debug(logginglevel.info, '>>> Resultados ' + dv2_results);
    
    // summary of vector results
    Integer sum2 = 0;
    for(Integer v : dv2_results)
      sum2 += v;
    system.debug(logginglevel.info, '>>> SUM ' + sum2);
    
    // MOD(sum, 11)
    Integer mod2 = Math.mod(sum2, 11);
    system.debug(logginglevel.info, '>>> MOD ' + mod2);
    
    // Validation of DV2
    Integer resDV2 = mod2; 
    system.debug(logginglevel.info, '>>> DV2 ' + resDV2);
  
  
    //E-Values (14/11/2012) added according to documentation
    if(resDV2==10)
    {
      resDV2 = 0;
    }
    
    
    String resDV = String.valueOf(resDV1) + String.valueOf(resDV2);
    system.debug(logginglevel.info, '>>> DV ' + dv + '  DV-Res ' + resDV);
    return resDV == dv;
  }

// ---------------------------------------------------- CPF Validator ------------------------------------------------------------


  
  public static boolean isValid_CPF(String value) {
   // system.debug(logginglevel.info, '### Validando CPF - Valor ' + value);
    
    if(value == null)
      value = '';
      
    String cpf = '';
    String dv = '';
    
    // validate format
    try {
      // validate format
      if(!Pattern.matches('^\\d{11}$', value)) {
        system.debug(logginglevel.info, '>>> Formato CPF inválido ' + value);
        return false;
      }
      
      // All digits should not be equal
      String all_equal = '';
      for(Integer d=0; d<=9; d++) { // testing digits from 0 to 9
        all_equal = '';
        for(Integer i=0; i <11; i++) // concatenating
          all_equal += String.valueOf(d);
        system.debug(logginglevel.info, '>>> all_equal ' + all_equal );
        if(value == all_equal ) {
          system.debug(logginglevel.info, '>>> Formato CPF inválido ' + value);
          return false;
        }
      }
      
      cpf = value.substring(0,9);
      dv = value.substring(9,11);
      system.debug(logginglevel.info, '>>> cpf ' + cpf);
      system.debug(logginglevel.info, '>>> dv ' + dv);
    } catch(Exception e) {
      system.debug(logginglevel.error, 'ERROR de Formato CPF Invalido ' + value);
      return false;
    }
    
    // fill a vector with each digit of nro to validate
    Integer[] dv1_digits = new Integer[ cpf.length() ];
    for(Integer i=0; i<dv1_digits.size();i++)
      dv1_digits[i] = Integer.valueOf(value.substring(i,i+1));
    system.debug(logginglevel.info, '>>> Digitos ' + dv1_digits);
    
    //  loading a vector with the same size to load multipliers
    Integer[] dv1_multipl = new Integer[]{10,9,8,7,6,5,4,3,2};
    system.debug(logginglevel.info, '>>> Multiplicadores ' + dv1_multipl);
    
    // third vector with the results of the multiplications
    Integer[] dv1_results = new Integer[ dv1_digits.size() ];
    for(Integer i=0; i<dv1_digits.size();i++)
      dv1_results[i] = dv1_digits[i] * dv1_multipl[i];
    system.debug(logginglevel.info, '>>> Resultados ' + dv1_results);
    
    // summary of vector results
    Integer sum = 0;
    for(Integer v : dv1_results)
      sum += v;
    system.debug(logginglevel.info, '>>> SUM ' + sum);
    
    // MOD(sum, 11)
    Integer mod = Math.mod(sum, 11);
    system.debug(logginglevel.info, '>>> MOD ' + mod);
    
    // Validation of DV1
    Integer resDV1 = 0; 
    if(mod < 2)
      resDV1 = 0;
    else
      resDV1 = 11 - mod;
    system.debug(logginglevel.info, '>>> DV1 ' + resDV1);
    
    
    //two digits of vector are added at the end the resDV1
    Integer[] dv2_digits = new Integer[ dv1_digits.size()+1 ];
    for(Integer i=0; i<dv1_digits.size();i++)
      dv2_digits[i] = dv1_digits[i];
    // add dv1 at the end
    dv2_digits[ dv2_digits.size()-1 ] = resDV1;
    system.debug(logginglevel.info, '>>> Digitos ' + dv2_digits);
    
    //  loading a vector with the same size to load multipliers
    Integer[] dv2_multipl = new Integer[]{11,10,9,8,7,6,5,4,3,2};
    system.debug(logginglevel.info, '>>> Multiplicadores ' + dv2_multipl);
    
    // third vector with the results of the multiplications
    Integer[] dv2_results = new Integer[ dv2_digits.size() ];
    for(Integer i=0; i<dv2_digits.size();i++)
      dv2_results[i] = dv2_digits[i] * dv2_multipl[i];
    system.debug(logginglevel.info, '>>> Resultados ' + dv2_results);
    
    // summary of vector results
    Integer sum2 = 0;
    for(Integer v : dv2_results)
      sum2 += v;
    system.debug(logginglevel.info, '>>> SUM ' + sum2);
    
    // MOD(sum, 11)
    Integer mod2 = Math.mod(sum2, 11);
    system.debug(logginglevel.info, '>>> MOD ' + mod2);
    
    // Validation of DV2
    Integer resDV2 = 0; 
    if(mod2 < 2)
      resDV2 = 0;
    else
      resDV2 = 11 - mod2;
    system.debug(logginglevel.info, '>>> DV2 ' + resDV2);
    
    String resDV = String.valueOf(resDV1) + String.valueOf(resDV2);
    system.debug(logginglevel.info, '>>> DV ' + dv + '  DV-Res ' + resDV);
    return resDV == dv;
  }

// ---------------------------------------------------- CUIT Validator ------------------------------------------------------------
  
  public static boolean isValid_CUIT(String InNroCuit,String billcon) {
  system.debug(logginglevel.info, '### Validando CNPJ - Valor ' + InNroCuit);
    
    boolean ret = false;
    Integer posicion, Coeficiente_Modulo, SumaTotal, Digito, Factor;
    String CLFSC_ARG = '54327654321';
    Integer CLFSC_ARG_LEN = 11;
    
    //control length of the entered number.
    if (InNroCuit.length() != CLFSC_ARG_LEN) {
      return false;
    }
    
    //validate format
    if(!Pattern.matches('^\\d{11}$', InNroCuit)) {
      return false;
    }
  
    //Entered number should not be less than or equal to zero
    if(Double.valueOf(InNroCuit) <= 0)
      return false;
    if(billcon=='AR')  {
    if(Integer.valueOf(InNroCuit.substring(0, 2)) != 30 && Integer.valueOf(InNroCuit.substring(0, 2)) != 33 && Integer.valueOf(InNroCuit.substring(0, 2)) != 20 && Integer.valueOf(InNroCuit.substring(0, 2)) != 23 && Integer.valueOf(InNroCuit.substring(0, 2)) != 24 && Integer.valueOf(InNroCuit.substring(0, 2)) != 27  && Integer.valueOf(InNroCuit.substring(0, 2)) != 34)
      return false;
      }  
    //Sum total of the entered digits multipled by the digits used in calculation of CUIT for Argentina
    SumaTotal = 0;
    posicion = 0;
    while(posicion < CLFSC_ARG_LEN) {
      Factor = Integer.valueOf( CLFSC_ARG.substring(posicion, posicion+1) );
      Digito = Integer.valueOf( InNroCuit.substring(posicion, posicion+1) );
      SumaTotal = SumaTotal + (Factor * Digito);
      posicion++;
      //System.debug('posicion : '+posicion+' Factor : '+Factor+' Digito : '+Digito+' SumaTotal : '+SumaTotal);
    }
    
    //Determine if the number entered is a valid CUIT number
    Coeficiente_Modulo = Math.mod(SumaTotal, CLFSC_ARG_LEN);
    if(Coeficiente_Modulo != 0) {
      return false;
    }
    
    return true;
  }
  /* ---------------------------------------------------- CUIT Validator For Argentina------------------------------------------------------------
  
   public static boolean isValid_CUITAR(String InNroCuitar) {
  
    system.debug(logginglevel.info, '### Validando CNPJ - Valor ' + InNroCuitar);
    
    boolean ret = false;
    Integer posicion, Coeficiente_Modulo, SumaTotal, Digito, Factor;
    String CLFSC_ARG = '54327654321';
    Integer CLFSC_ARG_LEN = 11;
    

    
    //validate number format
    if(!InNroCuitar.isNumeric()) {
      return false;
    }
  
   //control length of the entered number.
    if (InNroCuitar.length() != CLFSC_ARG_LEN) {
      return false;
    }
    
   //Entered number should not be less than or equal to zero
    if(Double.valueOf(InNroCuitar) <= 0)
      return false;
      
    //CMC-3
    //Validate first two digit of tax number

    if(Integer.valueOf(InNroCuitar.substring(0, 2)) != 30 && Integer.valueOf(InNroCuitar.substring(0, 2)) != 33 && Integer.valueOf(InNroCuitar.substring(0, 2)) != 20 && Integer.valueOf(InNroCuitar.substring(0, 2)) != 23 && Integer.valueOf(InNroCuitar.substring(0, 2)) != 24 && Integer.valueOf(InNroCuitar.substring(0, 2)) != 27)
      return false;

        
    //Sum total of the entered digits multipled by the digits used in calculation of CUIT for Argentina
    SumaTotal = 0;
    posicion = 0;
    while(posicion < CLFSC_ARG_LEN) {
      Factor = Integer.valueOf( CLFSC_ARG.substring(posicion, posicion+1) );
      Digito = Integer.valueOf( InNroCuitar.substring(posicion, posicion+1) );
      SumaTotal = SumaTotal + (Factor * Digito);
      posicion++;
    }
    
    //Determine if the number entered is a valid CUIT number
    Coeficiente_Modulo = Math.mod(SumaTotal, CLFSC_ARG_LEN);
    if(Coeficiente_Modulo != 0) {
      return false;
    }
    
    return true;
  
 } */   
//CMC-3 ---------------------------------------------------- CUIL/CDI Validator ------------------------------------------------------------
  public static boolean isValid_CUILCDI(String InNroCuil) {
  
    system.debug(logginglevel.info, '### Validando CNPJ - Valor ' + InNroCuil);
    
    boolean ret = false;
    Integer posicion, Coeficiente_Modulo, SumaTotal, Digito, Factor;
    String CLFSC_ARG = '54327654321';
    Integer CLFSC_ARG_LEN = 11;
    

    
    //validate number format
    if(!InNroCuil.isNumeric()) {
      return false;
    }
  
   //control length of the entered number.
    if (InNroCuil.length() != CLFSC_ARG_LEN) {
      return false;
    }
    
   //Entered number should not be less than or equal to zero
    if(Double.valueOf(InNroCuil) <= 0)
      return false;
      
    //CMC-3
    //Validate first two digit of tax number

    if(Integer.valueOf(InNroCuil.substring(0, 2)) != 20 && Integer.valueOf(InNroCuil.substring(0, 2)) != 23 && Integer.valueOf(InNroCuil.substring(0, 2)) != 24 && Integer.valueOf(InNroCuil.substring(0, 2)) != 27)
      return false;

        
    //Sum total of the entered digits multipled by the digits used in calculation of CUIT for Argentina
    SumaTotal = 0;
    posicion = 0;
    while(posicion < CLFSC_ARG_LEN) {
      Factor = Integer.valueOf( CLFSC_ARG.substring(posicion, posicion+1) );
      Digito = Integer.valueOf( InNroCuil.substring(posicion, posicion+1) );
      SumaTotal = SumaTotal + (Factor * Digito);
      posicion++;
    }
    
    //Determine if the number entered is a valid CUIT number
    Coeficiente_Modulo = Math.mod(SumaTotal, CLFSC_ARG_LEN);
    if(Coeficiente_Modulo != 0) {
      return false;
    }
    
    return true;
  
 } 
//CMC-3 ---------------------------------------------------- DNI/LE/LC Validator ------------------------------------------------------------
  public static boolean isValid_DNILELC(String InNroDni) {
  
  //control length of the entered number.
  Integer int1=7, int2=8;
    if (InNroDni.isNumeric()&&(InNroDni.length() == int1|| InNroDni.length() == int2)){ 
      return true;
      }
    else{  
      return false;  
    }
   
  }
//CMC-3 ----------------------------------------------------CI/PASAPORTE Validator ------------------------------------------------------------
  public static boolean isValid_CI(String InNroCi) {
  
//validate format
  if (!InNroCi.isAlphanumeric()) {
      return false;
    }
    return true;
  }
}