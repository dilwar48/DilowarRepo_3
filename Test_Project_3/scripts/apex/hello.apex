// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

public class hello{
    public static void method01(){
        system.debug('Test 11');
        String s1 = 'ABC';
        system.debug('S1 value is:' +s1);
        String s2 = 'XYZ';
        system.debug('S2 value is:' +s2);
    }
}

