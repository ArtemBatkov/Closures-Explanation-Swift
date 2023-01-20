//
//  main.swift
//  NonEscaping_and_Escaping_closures
//
//  Created by user233573 on 1/20/23.
//

import Foundation

//Section 1 -- What is a clouser?
/*
 Analogy:
 1) Bob gives Alice an instruction say "Hello!". Alice hears the
 instruction and says "Hello", saying "Hello" is a function
 
 2) Alice writes her age on a piece of paper and gives it to Bob
 The piece of paper is a variable
 
 3) Bob writes say "Hello" on a piece of paper and gives it to Alice. Alice reads the instruction on the piece of paper and says "Hello". The instuction as passed on the piece of paper is a closure.
 */

// A clouser is a block of code that can be passed to a function as a parameter, and the function can obtain new extra instuctions

//Syntax:
/*
 { (parameters) -> return type in
    statements
 }
 */

//Example 1:
let Alice: (String) -> () = {
    phrase in
    print("I am Alice. Bob said me to say: \(phrase)")
}
Alice("Hello") //"Hello" came from Bob
/*
 Alice is a closure of type (String) -> () means an input is a variable of type String, and returning type is Void
 When the closure is called you provide a value for the parameter.
 
Alice("Hello") means phrase(the var in the closure) = "Hello"
 */

//Example 2:
let AliceBool: (String) -> (Bool) = {
    phrase in
    print("I am Alice. Bob said me to say: \(phrase)")
    return true
}
print(AliceBool("Hello")) //You can see that true returns from the closure

//Difference between closures and functions: The parameters of closures are not named. When you declare the closure you can specify the type of the parameter (like String), but you don't specify a oarameter name.


//Section 2 -- Non-Escaping closures
print("\nSection 2 -- Non-Escaping closures")

//As it was mentioned in Section 1, we can pass closures as a parameter of the function, due to extend our functions functionality. For example, we want to sort an array before we can say the maximum value of it.

//Example 3
let Array = [10,-10,20,-20,30,-30,40,-40,50,-50]
func getMaxValue(array:[Int], newInstructions: ([Int])->Void){
    //array is an array of Ints
    var SortedArray: [Int] = []
    SortedArray = array.sorted(by: >) // from the biggest to lowest
    
    //when the sorting is complete. We want say the spot of function calling (line 95) that the sorting was competed do another instructions. But we have already passed the variable newInstructions: (Int)->Void that relates to code after the line 95. Only we have to do is say newInstructions(SortedArray)
    
    /*
     Saying another words our function looks like a function inside of the function.
     It looks like this:
     
     func getMaxValue(array:[Int], newInstructions: ([Int])->Void){
         var SortedArray: [Int] = []
         SortedArray = array.sorted(by: >)
         
        //This extends the function!!!!
     
        {//it's our code since line 95
            (newSortedArray) in // the input of the closure is an Int array, the closure returns nothing
         let maxValue = newSortedArray[0]
         print("The maxValue is \(maxValue)")
        }
     
        return
     }
     
     So, some additional instructions were added there. And, when we say newInstruction(SortedArray) that means we copied our instuctions from the spot where it was called and paste inside of the function. Like extend it.
     */
    newInstructions(SortedArray)
    return//end of the function
}

getMaxValue(array: Array){
    (newSortedArray) in
    let maxValue = newSortedArray[0]
    print("The maxValue is \(maxValue)")
    //THIS BLOCK OF CODE(95 to 98) WAS COPIED, PASTED AND EXECUTED INSIDE OF getMaxValue.
}

print("\n")
//Example 4 -- the easiest example
func Bob(AliceInstructions: (String)->Void){
    print("Hey, I am Bob. I give task to Alice. She must say Hello to everyone")
    //when Bob ends say the phrase above, Alice starts due Bob's instructions
    AliceInstructions("Hello Everyone")
    return
}

Bob { (phrase) in
    print("I am Alice. Bob told me to say \"\(phrase).\"")
}

/*
 Looks like:
 func Bob(AliceInstructions: (String)->Void){
     print("Hey, I am Bob. I give task to Alice. She must say Hello to everyone")
     //when Bob ends say the phrase above, Alice starts due Bob's instructions
     
    {
        phrase = "Hello Everyone"// "Hello Everyone" was transmitted by AliceInstructions  in
        print("I am Alice. Bob told me to say \"\(phrase).\"")
    }
    return //end of the function
 }
 */

//Overall, Non-Escaping means the closure that was passed as a parameter will executed inside of the function before return

//Section 3 -- Escaping closures
print("\nSection 3 -- Escaping closures")

//All code above works synchronous. That means the compiler will execute code line by line or step by step.
//But sometimes, we want do something in asynchornous way.
/* Example:
 The user uses Youtube mobile app. He wants download a video. He clicks a download button, and does the app block and wait when the downloading finishes or it continues working separatly? Of course, the user can watch other videos, post some comments, press a like button, the process of the app is not standing in one spot. If we write a code synchronous, the thread will wait until it won't finish, but asyncronous means do something in another wait.
 
    Say simplier:
 User clicks download a video -> downloadFunction() will be called -> the function makes new asynchronous request and say the MainThread "Ok, I started downloading, but let's be back when it is done". -> function finishes  -> ...waiting...(while waiting the MainThread is working. It hasn't stoped) -> the video was downloaded and MainThread is paused, downloadFunction calls again, but starting in asychronous block of code -> Notification for user.
 */

//Example 5 -- simple way to explaine
func Delay2SecSynchronous(){
    print("\nSynchronous:")
    print("\(#function) has started")
    sleep(2)
    print("2 sec passed. End of the function.\n")
}

Delay2SecSynchronous()



func Delay2SecAsynchronous(newInstructions: @escaping (String)->Void){
    print("\nAsynchronous:")
    print("\(#function) has started")
    print("Ok. I ran the new thread but will call it when it is done! For now, I will finish move forward.\n")
//    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2.0, execute: {
//        newInstructions("2 sec passed")
//    })
    
    let queue = DispatchQueue(label: "NewThread", attributes: .concurrent)
    queue.asyncAfter(deadline: .now() + 2.0 , execute: {
        newInstructions("2 sec passed")
    })
    
    print("Oh, I can see there are some additional tasks in this function\n")
    let result = 50 + 50
    print("The task is sum 50 + 50 = \(result). Everything was done, but I remember about async, and I am waiting for it.\n")
}


Delay2SecAsynchronous{
    (phrase) in
    print("\n\(phrase). I've come to the \(#function) again starting with this line")
    let NewResult = 50 - 50
    print("\nNew task is 50 - 50 = \(NewResult). All was done, I am going to leave the function.")
}

print("\n")
