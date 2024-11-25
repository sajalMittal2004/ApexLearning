public class ApexCollectionType {
    public static void practiceOnMap(){
        Map<String, List<String>> mapToStoreDepartmentAndRelatedEmployee = new Map<String, List<String>>();
        mapToStoreDepartmentAndRelatedEmployee.put('Sales', new list<String>{'John Doe','Jane Smith','Michael Brown'});
        mapToStoreDepartmentAndRelatedEmployee.put('Marketing', new list<String>{'Emily Davis','David Wilson','Sarah Miller'});
        mapToStoreDepartmentAndRelatedEmployee.put('Engineering', new list<String>{'Chris Johnson','Laura Martinez','Vikas Roy'});
    }
    
    public static void practiceOnSet(){
        Set<String> studentsOfJava = new Set<String>{'Aarav','Riya','Kabir','Zara','Vivaan'};
        Set<String> studentsOfPython = new Set<String>{'Aarav','Arjun','Kabir','Nisha','Rahul'};             

        //1. Union of studentsOfJava & studentsOfPython sets
        Set<String> unionOfBothSet = new Set<String>();
        unionOfBothSet.addAll(studentsOfJava);
        unionOfBothSet.addAll(studentsOfPython);
        
        //2. Intersection of studentsOfJava & studentsOfPython sets
        Set<String> intersectionOfBothSet = new Set<String>(studentsOfJava);
        intersectionOfBothSet.retainAll(studentsOfPython);

        //3. Difference of two set(studentsOfJava - studentsOfPython)
        Set<String> studentsOfJava_Minus_studentsOfPython = new Set<String>(unionOfBothSet);
        studentsOfJava_Minus_studentsOfPython.removeAll(studentsOfPython);
        
        // Similarly studentsOfPython - studentsOfJava
        Set<String> studentsOfPython_Minus_studentsOfJava = new Set<String>(unionOfBothSet);
        studentsOfPython_Minus_studentsOfJava.removeAll(studentsOfJava);
    }
    
    public static void practiceOnList(){
        List<Integer> numberList = new List<integer>();
        for(Integer i = 0; i < 10; i++){
            numberList.add(Integer.valueOf(Math.random()*10));
        }
        // 1. sorting using predefined sort() method
        // numberList.sort();
        	
        // 2. using for loop
        for(Integer i = 0; i < numberList.size(); i++){
            for(Integer j = 0; j < numberList.size()-1-i; j++){
                if(numberList[j] > numberList[j+1]){
                    Integer temp = numberList[j];
                    numberList[j] = numberList[j+1];
                    numberlist[j+1] = temp;
                }
            }
        }
    }
}