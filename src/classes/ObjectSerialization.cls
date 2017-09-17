global class ObjectSerialization {

    //public string myFilter { get  ; set ; }
   private List<Account> accounts;
   public List<Account> ObjectSerialization() {
          String Name1='Name';
          string myFilter ='a';
          system.debug('myFilter ' + myFilter );
          accounts= [select name,Id from Account where name like   :myFilter +'%'  ];
          
          Map<String, SObjectField> fields = Account.SObjectType.getDescribe().fields.getMap();
          List<Account> acc = new List<Account>();
          acc = [select name,Id from Account where name like   :myFilter +'%' limit 20];  
           return acc;
      }
    public static void TestGovLimitStatements(List<Account> accountList){
		//SObject s = [SELECT Name  FROM Account LIMIT 1];
		List<Account> accNam = new List<Account>();
		integer intnu = 1;
		for(SObject s : accountList){
			system.debug('for Started >>>>>>>>>>>>>> ');
			/*for(integer i=0;i<201;i++)
		    {
		    	/*Account acNew = new Account();
		        String o =(String) s.get('Name') +(String) s.get('Name');
		        system.debug('Acc Name o' + o);
		     	acNew.Name= 0+String.ValueOf(i);
		     	accNam.add(acNew);
		     	intnu++;
		     	system.debug('Acc Name ' + acNew.Name);
		     	system.debug('Acc Number In intnu' + intnu);*/
		     //	system.debug('Acc Number' + o);
			//}*/
			//system.debug('Acc Number intnu' + intnu);
			accNam.add((Account)s);
		}
		system.debug('Acc Number accNam' + accNam);
		delete accNam;
    }
}