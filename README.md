# The Common Lisp Cheat Sheet

1. [The Basics](#org77d32bb)
   1. [Global Variables](#org7babf58)
   2. [Global Functions](#org7561355)
   3. [Assignment](#orgaf86fa8)
   4. [Input & Output](#orgd660dc0)
   5. [Numerical Functions](#org14d1d98)
   6. [Text Functions](#org509a49b)
2. [Logic & Equality](#orgbb85d6f)
   1. [Type Predicates](#org3d5c207)
   2. [Boolean & Logic](#org2ea5239)
   3. [Equality](#org95cc4a3)
   4. [Blocks](#orgf591e22)
   5. [Conditionals](#org3a0d565)
3. [Looping](#orge0a634f)
   1. [Basic Looping](#org436ea7c)
   2. [Advanced Looping](#org83b693d)
4. [Local Variables & Functions](#org92b85fc)
   1. [Local Variables](#org9f76fb8)
   2. [Local Functions](#org9b010ba)
5. [More on Functions](#org283acf2)
   1. [Lambda Expressions](#orgfceb856)
   2. [Function Parameters](#org7a4f5d3)
   3. [Multiple Values](#org86b4d87)
   4. [Apply & Funcall](#orgc982106)
   5. [Mapping Functions](#orgc1e2096)
6. [More on Lists](#org721d229)
   1. [List Functions](#org681ae0f)
   2. [Push, Pop & Reverse](#orgc1be892)
   3. [Association Lists](#org34d47a7)
7. [More on Sequences](#org4faae7d)
   1. [Arrays](#org6377bc9)
   2. [Sequence Functions](#org469c85e)
   3. [Keyword Arguments](#org5e7bf39)
8. [Data Structures](#org94ffa30)
   1. [Hash Tables](#orgb7bdb2a)
   2. [Structures](#orge20b38c)
   3. [Common Lisp Object System (CLOS)](#orgab67257)
9. [Other](#orge334e2e)
   1. [Reading & Writing to Files](#org5926aaf)
   2. [Packages](#orgc750fcf)


<a id="org77d32bb"></a>

# The Basics

<a id="org7babf58"></a>

## Global Variables

We can define global variables with `DEFPARAMETER` and `DEFVAR`. `DEFPARAMETER` will always bind the supplied value, while `DEFVAR` will only bind a value to a variable if no binding exists.

```lisp
(defvar *x*) ;; Establish an unbound variable
(defparameter *x* 15) ;; Assign the value 15 to X
(defvar *x* 10) ;; Does nothing as X already bound
(defconstant +my-constant+ 20) ;; Define global constant
```

<a id="org7561355"></a>

## Global Functions
`DEFUN` - define global functions.

```lisp

(defun function-name (parameter*)
  "Optional documentation string."
  body-form*)
```


<a id="orgaf86fa8"></a>

## Assignment

`SETF` - assignment operator. Places are typically either symbols, representing variables or functions, or getter forms that access particular places in objects that we wish to modify.

```lisp
(setf place value)

(setf x 10)    ;; Set x to 10
(setf x 1 y 2) ;; Set x to 1 and y to 2

;; Example of using a getter with setf
(defvar *list* '(1 2 3 4)) 
(setf (car *list*) 5)
*list* ;; Returns (5 2 3 4)
```


<a id="orgd660dc0"></a>

## Input & Output

The LISP reader consists of three primary functions
-  `READ` is used to parse input into Lisp objects and reads exactly one expression, regardless of newlines
-  `READ-LINE` reads all characters up to a newline, returning a string
-  `READ-FROM-STRING` takes a string and returns the first expression from it

Some examples you can experiment with.
```lisp
(defparameter my-variable nil)
(setf my-variable (read-line))
(setf my-variable (read))
(setf my-variable (read-from-string "(1 2 3)"))
```

The most useful LISP printing functions are:
-   `PRINT` and `PRIN1` are used to generate output useful for programs (the former adds a newline to the output whilst the latter does not)
-   `PRINC` is used for output for people
-   `FORMAT` is a highly configurable printer and the most commonly used printer

```lisp
(format destination control-string optional-arguments*) ;; syntax of format
```

The first argument of the `FORMAT` function is the destination where the output will be printed.

-   A value of `T` will send the out to the stream `*​STANDARD-OUTPUT​*` (typically the main screen of your LISP system) whilst `NIL` here will return the output as a string. We can also supply a stream here
-   The second argument is the string that we want to print. However, we can enter directives (preceded by `~`) to add complex behaviour to the string, such as
    -   `~%` to print newlines
    -   `~A` to print LISP objects for humans
    -   `~S` to print LISP objects for computers, i.e. suitable as as input for the LISP reader

The third (optional) argument of the `FORMAT` function is the arguments we want to supply to the control string. Each `~A` or `~S` in the control-string takes a successive argument from here and places it into the string.

This is best illustrated by the following examples. Note how Bob is quoted in the second example, as the printed representation of LISP strings includes quotes.

```lisp
(format t "Dear ~A, ~% How are you?" "Bob") ;; Prints to screen: Dear Bob, How are you?
(format t "Dear ~S, How are you?" "Bob") ;; Prints to screen: Dear "Bob", How are you?
(format nil "~A ~A" "Number is:" (+ 1 2)) ;; Returns "Number is: 3" (a string)
```


<a id="org14d1d98"></a>

## Numerical Functions
Basic numerical functions include `+`, `*`, `-`, `/`. They can take more than two operands.
```lisp
(+ 4 7 9) ;; 20
```

Numerical comparisons can be achieved with `=`, `/=`, `>`, `<`, `>=` and `<=`. With three or more arguments, these functions act as range checks.
For example, the below returns true as X is between 0 and 5 inclusive.

```lisp
(defparameter x 5)
(<= 0 x 5)
```

The below returns false as X > Y:
```lisp
(defparameter y 4)
(< 0 x y 6)
```

The below returns true as Y < X < 6:
```lisp
(< 0 y x 6)
```

Other useful numerical functions are below.
```lisp
(exp 3) ;; e^3
(expt 4 5) ;; 4^5
(log 8 2) ;; log of 8 in the base 2, i.e. 3
(sqrt 9) ;; square root of 9, i.e. 3
(max 1 3 5 4 2) ;; 5
(min 1 -1 2 3 4) ;; -1
(abs -3) ;; 3
```

More details on numerical operations: [Common Lisp, the Language 2nd Edition](https://www.cs.cmu.edu/Groups/AI/html/cltl/clm/node121.html).


<a id="org509a49b"></a>

## Text Functions
`CONCATENATE` concatenates strings:
```lisp
(concatenate 'string "Hello, " "world" ". Today is good.")
```

`LENGTH` returns the number of characters in a string:
```lisp
(length "Common") ;; Returns 6
```
`SEARCH` will search for a substring within a string.
```lisp
(search "term" "the term is search within this string") ;; Returns 4, the starting position of the first string within the second string
```

Below are comparison functions for strings. Replace STRING with CHAR in the below to get the equivalent character comparison function.
| Case Sensitive | Case Insensitive    |
|-------------- |------------------- |
| STRING=        | STRING-EQUAL        |
| STRING/=       | STRING-NOT-EQUAL    |
| STRING<        | STRING-LESSP        |
| STRING<=       | STRING-NOT-GREATERP |
| STRING>        | STRING-GREATERP     |
| STRING>=       | STRING-NOT-LESSP    |


<a id="orgbb85d6f"></a>
# Logic & Equality

<a id="org3d5c207"></a>

## Type Predicates
LISP objects can belong to multiple data types. Test whether an object is of a particular type with `TYPEP`.

```lisp
(typep "My String" 'string) ;; T
```

Other type predicate functions include ATOM, NULL, ZEROP, NUMBERP, EVENP, LISTP, ARRAYP, PLUSP, CHARACTERP, ODDP, SYMBOLP, PACKAGEP, MINUSP, STRINGP and ODDP.


<a id="org2ea5239"></a>

## Boolean & Logic

Falsity is represted by `NIL` and all other values represent truth.

The function `AND` returns `NIL` if any of its arguments are false and returns the value of the last argument if all arguments are true. The below will return 5 as all the arguments are true:

```lisp

(and t (+ 1 2) (* 1 5))

```

The function `OR` returns the first argument that is true and `NIL` if no argument is true. The below returns 3, the first non-nil value in the form:

```lisp
(or nil (+ 1 2) (* 1 5))
```


<a id="org95cc4a3"></a>

## Equality
Common Lisp has a few functions for testing equality of two objects. Generally speaking, you can't go wrong with `EQUAL`
-   `EQ` compares equality of memory addresses and is the fastest test. It is useful to compare symbols quickly and to test whether two cons cells are physically the same object. It should not be used to compare numbers
-   `EQL` is like `EQ` except that it can safely compare numbers for numerical equality and type equality. It is the default equality test in many Common Lisp functions
-   `EQUAL` is a general purpose test that, in addition to being able to safely compare numbers like `EQL`, can safely compare lists on an element by element basis. Lists are not unique and `EQ` and `EQL` will fail to return equality on equivalent lists if they are stored in different memory addresses
-   `EQUALP` is a more liberal version of `EQUAL`. It ignores case distinctions in strings, among other things
-   `=` is the most efficient way to compare numbers, and the only way to compare numbers of disparate types, such as 3 and 3.0. It only accepts numbers


<a id="orgf591e22"></a>

## Blocks

`PROGN` allows multiple forms to be evaluated and the value of the last is returned as the value of the `PROGN`. The below will print "Hello" and "World" and return 10:

```lisp
(progn
  (print "Hello")
  (print "World")
  (+ 5 5))
```

`BLOCK` is similar, but it is named and has a mechanism for out-of-order exit with the `RETURN-FROM` operator.
-   The value of the last expression in a block is returned as the value of the block (unless there is an early exit by `RETURN` or `RETURN-FROM`)
-   All other expressions in the block are thus only useful for their side effects
The below constructs a block named MY-BLOCK and returns 10 as it returns from the block when evaluating the `RETURN-FROM` form:

```lisp
(block my-block
  (print "We see this")
  (return-from my-block 10)
  (print "We will never see this"))
```

`RETURN` (macro) returns its argument as the value of an enclosing `BLOCK` named `NIL`. Many Common Lisp operators that take a body of expressions implicitly enclose the body in a `BLOCK` named `NIL` and we can use `RETURN` in these forms:

```lisp
(dolist (i '(1 2 3 5 6 7))
  (if (= i 3)
      (return 10))
  (print i))
```


<a id="org3a0d565"></a>

## Conditionals
The five main conditionals are `IF`, `WHEN`, `UNLESS`, `COND` and `CASE`.


`IF` - NO implicit `PROGN`
```lisp
(if (equal 5 (+ 1 4)) ;; note there is no implicit 'progn'
    (print "This is true")
    (print "This if false"))
```

`WHEN` - implicit `PROGN`

```lisp

(when (equal 5 (+ 1 4))
  (print "Print if statement is true")
  (print "Print this also"))

```

`UNLESS` - implicit `PROGN`):

```lisp

(unless (equal 3 (+ 1 4))
  (print "Only print if condition is false")
  (print "Print this also"))

```

`COND` - multiple ifs, implicit `PROGN`. The form exits on the first true:
```lisp

(cond ((equal 5 3) (print "This will not print"))
      ((equal 5 5) (print "This will print"))
      ((equal 5 5)
       (print "This will not print as the")
       (print "form exited at first true")))

```

Example of a `CASE` form (multiple ifs on one variable, implicit `PROGN`). Cases are literal and not evaluated. The form exits on the first true:

```lisp
(case (read)
  (1 (format t "~% Monday"))
  (2 (format t "~% Tuesday"))
  (3 (format t "~% Wednesday"))
  (4 (format t "~% Thursday"))
  (5 (format t "~% Friday"))
  (6 (format t "~% Saturday"))
  (7 (format t "~% Sunday"))
  (otherwise "Not an integer between 1 and 7"))
```


<a id="orge0a634f"></a>

# Looping
<a id="org436ea7c"></a>

## Basic Looping
`DOLIST` will iterate over the items of a list and execute the loop body for each item of the list.

```lisp
(dolist (my-variable my-list optional-result-form)
  body-form*)

(dolist (i '(1 2 3 5 6 7)) ;; prints numbers 1 to 7
  (print i))
```

`DOTIMES` iterates from 0 to one less than the end number. If an optional result form is supplied, it will be evaluated at the end of the loop.

```lisp
(dotimes (my-variable end-number optional-result-form)
  body-form*)

(dotimes (i 5 T) ;; prints numbers 0 to 4
  (print i))
```

<a id="org83b693d"></a>
## Advanced Looping
Below is the syntax of the `DO` macro.

```lisp

(do ((var1 init1 step1)
     ...
     (varn initn stepn))
    (end-test result-forms*)
  body-forms*)

```

The below example will return 81 and print 1, 0, 1, 4, 9, 16, 25, 36, 49 and 64 on newlines. During each iteration, LOOP-STEP is increased by one and SQUARE is set to the square of LOOP-STEP:

```lisp

(do ((loop-step 0 (+ loop-step 1))
     (square 1 (* loop-step loop-step)))
    ((= 10 loop-step) square) ; Stop at 10
  (print square)) ; Print square at each step

```

Below are examples of the `LOOP` macro, some from [Peter D. Karp's Guide](http://www.ai.sri.com/pkarp/loop.html). The first will return a list of the doubles of each number in the original list:

```lisp

(defvar my-list-1 '(1 2 3 4 5 6))

;; Returns (2 4 6 8 10 12)

(loop for x in my-list-1
      collect (+ x x))

```

The below will print each of the numbers in the list iteratively:

```lisp

(loop for x in my-list-1
       do (print x))

```

The below will only collect even numbers:

```lisp

(loop for x in my-list-1
      if (evenp x)
      collect x)

```

The below is an example of iterating across two lists, stopping the loop at the end of the shorter list:

```lisp

(defvar my-list-2 '(a b c d e))
(loop for x in my-list-1
      for y in my-list-2
      do (format t "X: ~a, Y: ~a, " x y))

```

We can also do simple loops with a counter:

```lisp
(loop for x from 1 to 5
       do (print x))
```

Below is an example of how we can use the `LOOP` macro to check whether a certain predicate is true at some point within a list:

```lisp
(loop for x in '(abc 2) 
      thereis (numberp x))
```

We can also check whether a predicate is never true within a loop:

```lisp
(loop for x in '(abc 2) 
      never (numberp x))

```

We can also check whether a predicate is always true within a loop:

```lisp
(loop for x in '(abc 2)
	always (numberp x))
```
Below is an example of terminating a loop early:

```lisp
(loop for x from 1
      for y = (* x 10)
      while (< y 100)
      do (print (* x 5))
      collect y)
```

Finally, a few more examples illustrating the versatility of the `LOOP` macro:

```common-lisp
(loop for x in '(a b c d e 1 2 3 4)
      until (numberp x)
      do
      collect (list x 'abc))

(loop for x in '(a b c d e)
      for y from 1
      when (> y 1) do (format t ", ")
      do (format t "~A" x))

(loop for x in '(a b c d e)
    for y from 1
    if (> y 1)
    do (format t ", ~A" x)
    else do (format t "~A" x))
```


<a id="org92b85fc"></a>

# Local Variables & Functions

<a id="org9f76fb8"></a>

## Local Variables

`LET` and `LET*` allow us to create local variables that can only be accessed within their closures. 
`LET` binds in parallel - you cannot refer to another variable in the `LET` form when setting the value of another. 
`LET*` binds in sequentially - you can refer to the value of any previously bound variables. This is useful when you want to assign names to several intermediate steps in a long computation.


```lisp
(let ((var-1 value-1)
      ...
      (var-n value-n))
  body-form*)


;; Prints 10
(let* ((x 5)
       (y (+ x x)))
  (print y))

```


<a id="org9b010ba"></a>

## Local Functions

`DEFUN` functions are global functions and can be accessed anywhere. 
We can define local functions `LABELS`, which are only accessible within their context.
```lisp
(labels ((fn-1 args-1 body-1)
	 ...
	 (fn-n args-n body-n))
  body-form*)
```

They take a similar format to a `DEFUN` form. Within the body of the `LABELS` form, function names matching those defined by the `LABELS` refer to the locally defined functions rather than any global functions with the same names.

Below is an example of a `LABELS` form that will return 12, the result of (+ 2 4 6), where 2, 4 and 6 are the results of evaluating the three local functions defined in the form.

```lisp
(labels ((first-function (x) (+ x x))
	 (second-function (y) (* y y))
	 (third-function (z) (first-function z)))
  (+ (first-function 1)
     (second-function 2)
     (third-function 3))) 
```


<a id="org283acf2"></a>
# More on Functions
<a id="orgfceb856"></a>
## Lambda Expressions

Lambda expressions allow us to create unnamed functions. These are useful when writing small functions for certain tasks. Below is an example that returns 101:

```lisp
((lambda (x)
   (+ x 100))
 1)
```


<a id="org7a4f5d3"></a>
## Function Parameters
By default, a function call must supply values for all parameters that feature in the function definition. We can modify this behaviour with the `&optional`, `&key` and `&rest` tokens.

The `&optional` token allows us to distinguish between required parameters, placed before the `&optional` token, and optional parameters, placed after the token:
```lisp

(defun make-a-list (a b c d &optional e f g)
  (list a b c d e f g))

(make-a-list 1 2 3 4 5) ;; Returns (1 2 3 4 5 NIL NIL)
```

One drawback of the `&optional` token, is that we need to supply values for E and F if we want to supply the value for G, as arguments in a function call are assigned to the parameters in order.
To overcome this, we utilise the `&key` token to be able to specify which optional parameter we want to assign a value to. Below is an example of this.

```lisp
(defun make-a-list-2 (a b c d &key (e 1) f g)
  (list a b c d e f g))

(make-a-list-2 1 2 3 4 :g 7) ;; Returns (1 2 3 4 1 NIL 7)
```

In general, `&key` is preferable to `&optional` as it allows us to have greater control in our function calls. It also makes code easier to maintain and evolve as we can add new parameters to a function without affecting existing function calls (useful when writing libraries that are already dependencies for other programs).

Finally, the `&rest` token, placed before the last variable in a parameter list, allows us to write functions that can accept an unknown number of arguments. The last variable will be set to a list of all the remaining arguments supplied by the function call:

```lisp

(defun make-a-list-3 (a b c d &rest e) (list a b c d e))

(make-a-list-3 1 2 3 4 5 6 7 8) ; (1 2 3 4 (5 6 7 8))

```

We can utilise multiple tokens in the same function call, as long as we declare them in order:

1.  First the names of required parameters are declared
2.  Then the `&optional` parameters
3.  Then the `&rest` parameter
4.  Finally the `&keyword` parameters are declared


<a id="org86b4d87"></a>

## Multiple Values

The `VALUES` function returns multiple values and can be used as the last expression in the body of a function.

```lisp
(values 1 nil (+ 2 4)) ;; returns 1, NIL and 6
```

If a `VALUES` function is supplied as an argument to a form which is only expecting one value, the first value returned by the `VALUES` function is used and the rest are discarded:

```lisp
(+ 5 (values 1 nil (+ 2 4))) ;; Returns 6
```

The `MULTIPLE-VALUE-BIND` macro is used to receive multiple values. The first argument of this macro is a list of parameters and the second is an expression whose values are bound to the parameters. We can then use these bindings in the body of the `MULTIPLE-VALUE-BIND` macro.

```lisp
(multiple-value-bind (x y z) (values 1 2 3) ;; Returns (1 2 3)
   (list x y z)) 
```

If there are more variables than values, the leftover variables will be bound to NIL. If there are more values than variables, the extra values will be discarded.


<a id="orgc982106"></a>

## Apply & Funcall

Functions in LISP are first-class objects that generally support all operations available to other data objects, such as being modified, passed as an argument, returned from a function and being assigned to a variable.

The `FUNCTION` special operator (shorthand `#'`) returns the function object associated with the name of function that is supplied as an argument:

```lisp

(function +)

;; Equivalent syntax

#'+

```

`APPLY` takes a function and a list of arguments for it and returns the result of applying the function to its arguments.

Note how we have to use to sharp-quote `#'` to pass the `+` function as an object into the `APPLY` function. Without doing so, LISP will return an error as it will try to evaluate `+`, which is not legally permissible in the below example.

```lisp

(apply #'+ '(1 2 3)) ;; returns 6

;; Lambda expression
(apply #'(lambda (a b c)
	   (+ a b c))
       '(1 2 3))

```
 `FUNCALL` - similar to `APPLY`, but allows us to pass arguments individually and not as a list.
```lisp
(funcall #'+ 1 2 3) ;; 6
```

<a id="orgc1e2096"></a>

## Mapping Functions

Mapping is a type of iteration in which a function is successively applied to pieces of one or more sequences.

`MAPCAR` operates on successive elements of lists and returns a list of the result of the successive calls to the function specified. 
`MAPLIST` operates on successive CDRs of the lists, ONLY lists.
`MAP` - map over other types of sequences, not only lists.

```lisp
(mapcar #'(lambda (x) (- 0 x)) '(1 2 3)) ;; (-1 -2 -3)
(maplist #'(lambda (x) x) '(a b c d)) ;; ((A B C D) (B C D) (C D) (D))

(map result-type function &rest sequences)

(map 'list #'(lambda (x) (list x x)) "abc") ;; Returns a list ((#\a #\a) (#\b #\b) (#\c #\c))

(map 'string
     #'(lambda (x) (if (oddp x) #\1 #\0))
     '(1 2 3 4)) ;; Returns "1010"
```


<a id="org721d229"></a>

# More on Lists


<a id="org681ae0f"></a>

## List Functions

`NTH` - access a particular element of a list.
`NTHCDR` - access a particular CDR of a list.
`FIRST`, `SECOND`, &#x2026;, `TENTH` - access the first ten elements of a list.
`LAST` - access the last CDR of a list.

```lisp
(nth 3 '(a b c d e f g)) ;; D
(nthcdr 3 '(a b c d e f g)) ;; (D E F G)
(first '(a b c d e f g)) ;; (A)
(last '(a b c d e f g)) ;; (G)
```

Lists can be thought of as sets and a number of useful functions exist to perform set operations.

`MEMBER` and its variants are useful functions to test whether certain elements exist within a list.

```lisp
(member 'b '(a b c)) ;; (B C), the cdr from the position B is found
(member-if #'oddp '(2 3 4)) ;; (3 4), 3 is odd
```

We can also specify the test to apply (the default is `EQL`):
```lisp
(member 'b '(a b c) :test #'equal) 
```

`ADJOIN` joins an object onto a list if it is not already a member.
```lisp
(adjoin 'b '(a b c)) ;; (A B C)
(adjoin 'z '(a b c)) ;; (Z A B C)
```

`UNION`, `INTERSECTION` and `SET-DIFFERENCE`

```lisp
(union '(a b c) '(c b s)) ;; (A B C S)
(intersection '(a b c) '(c b s)) ;; (C B) 
(set-difference '(a b c) '(c b s)) ;; (A) - {first set} \ {second set}
```

`REDUCE` - extend functions that only take two variables. It takes two arguments: a function (which must take exactly two values) and a sequence.
-   The function is initially called on the first two elements of the sequence, and thereafter with each successive element as the second argument
-   The value returned by the last call is the value returned by the `REDUCE` function

```lisp
(reduce #'intersection '((b r a d) (b a d) (c a t))) ;; returns (A), the intersection of these three lists
```


<a id="orgc1be892"></a>

## Push, Pop & Reverse
`PUSH` - push an element to the front of a list, 
`POP` - remove and return the first element of the list.
Both are destructive.

```lisp
(defparameter *my-list* '(2 3 4))
(push 1 *my-list*) ;; pushing 1 to the front of \*​MY-LIST\*
*my-list* ;; (1 2 3 4)

(pop *my-list*) ;; 1, the car of *my-list*
*my-list* ;; (2 3 4) - 1 has been removed
```

`REVERSE` - reverse the order of elements within a list (destructive, `NREVERSE` is non-descructive)
```lisp
(reverse '(a b c d e f)) ; returns (F E D C B A)
```


<a id="org34d47a7"></a>
## Association Lists

Association lists are very useful for mapping values to keys. They are lists of pairs (i.e. conses), where CARs are keys and CDRs are values.
```lisp
(defvar my-a-list '((one . 1) (two . 2)))
```

Below is an example of returning a new association list by adding an entry to the front of a pre-existing association list:

```lisp
(acons 'three 3 my-a-list) ;; Returns ((THREE . 3) (ONE . 1) (TWO . 2))
```

Below is an example of creating an association list from lists of keys & datums:

```lisp
(pairlis '(one two three) '(1 2 3))
```

`ASSOC` - retrieve the pair associated with a key.
`RASSOC` - retrieve the pair associated with a datum (value).

```lisp
(assoc 'one my-a-list) ;; (ONE . 1)
(rassoc 2 my-a-list :test #'=) ;; (TWO . 2)
```


<a id="org4faae7d"></a>

# More on Sequences

Sequences are a data type and lists, strings, arrays are all of type sequence.


<a id="org6377bc9"></a>

## Arrays

`MAKE-ARRAY` creates arrays

```lisp
(defparameter my-array ;; create a 2x3 array
  (make-array '(2 3) :initial-element nil))
```

`AREF` and `SETF` - access elements and set their values

```lisp
(aref my-array 0 0) ;; NIL (value has not been set)

(setf (aref my-array 0 0) 'b) ;; set the value to B

(aref my-array 0 0) ;; B
```

`:INITIAL-ELEMENT` - set the value of every element of an array to the provided argument.

```lisp
(setf my-array ;; set every element to 2
       (make-array '(2 3)
		   :initial-element '((1 2 3) (1 2 3))))
```

`ARRAY-RANK` and `ARRAY-DIMENSION` - retrieve the the number of dimensions and the number of elements in a given dimension respectively:

```lisp
(array-rank my-array)) ;; Returns 2
(array-dimension my-array 0) ;; Returns 2
(array-dimension my-array 1) ;; Returns 3
```

`:INITIAL-CONTENTS` is used to set the array to an object provided.
```lisp
(defparameter my-vector
  (make-array 3 :initial-contents '("a" 'b 3)))
```

A one-dimensional array is also known as a vector and the above example created one. Vectors can also be created with `VECTOR`:
```lisp
(vector "a" 'b 3)
```

The most famous vectors in LISP are strings. Strings are specialised vectors whose elements are characters.

<a id="org469c85e"></a>

## Sequence Functions

Sequences have many useful functions. We can use `LENGTH` to return the number of items in a sequence. 

```lisp
(length '(a b c d e f)) ;; Returns 6
```

`REMOVE` and variants - handy filter functions.
```lisp
(remove 'a '(c a r a t)) ;; Returns (C R T) as a new list
(remove-duplicates "abracadabra") ;; Returns "cdbra", preserving only the last duplicate of each item
(remove-if #'oddp '(1 2 3 4 4)) ;; (2 4 4)
```

`SUBSEQ` - extract a portion of a sequence. Its arguments are a list, the starting position and an optional ending position (which is not to be included in the subsequence).
`SORT` takes a sequence and a comparison function of two arguments and destructively returns a sequence sorted according to the function.

```lisp
(subseq '(a b c d e f) 1 4) ;; (B C D)
(sort (list 1 4 2 5 6) #'>) ;; (6 5 4 2 1) - sorting in descending order
```

`EVERY` and `SOME` test whether a sequence satisfies a provided predicate.

```lisp
(every #'oddp '( 1 2 5)) ;; NIL (not every item is odd)
(some #'oddp '( 1 2 5)) ;; T (some of the items are odd)
(every #'> '(1 3 5) '(0 2 4)) ;; T (in an element-wise comparison, items from the firt sequence are greater than those of the second sequence)
```

`FIND`, returns the leftmost element
`POSITION` returns the position of such an item, as an integer.
`COUNT` - returns the number of instances of the element within the sequence.
`SEARCH` - returns the position of one sequence within another.

```lisp
(find 1 '(1 2 3 4)) ;; returns 1, the item we're searching for
(position 1 '(1 2 3 4)) ;; returns 0, the position
(count 1 '(1 2 3 1 1 4)) ;; returns 3 
(search "Hello" "Hi! Hello, World!") ;; returns 4
```
<a id="org5e7bf39"></a>

## Keyword Arguments

Many list and sequence functions take one or more keyword arguments from the below table. For example, we can use `POSITION` to return the position of an element within a sequenc (or NIL if not found) and use keyword arguments to determine where to begin the search.
```lisp
(position #\a "fantasia" :start 3 :end 7) ;; Returns 4
```

| Parameter | Position                            | Default  |
|--------- |----------------------------------- |-------- |
| :key      | A function to apply to each element | identity |
| :test     | The test function for comparison    | eql      |
| :from-end | If true, work backwards             | nil      |
| :start    | Position at which to start          | 0        |
| :end      | Position, if any, at which to stop  | nil      |


<a id="org94ffa30"></a>
# Data Structures


<a id="orgb7bdb2a"></a>
## Hash Tables
The objects stored in a hash table or used as keys can be of any type. Hash tables can accommodate any number of elements, because they are expanded when they run out of space.
`MAKE-HASH-TABLE`
`GETHASH` - retrieve a value
`SETF` - set a value 
`REMHASH` - remove items from the hash table


```lisp
(defparameter my-hash-table (make-hash-table))
(gethash 'color my-hash-table)  ;; NIL, not yet set
(setf (gethash 'color my-hash-table) 'red)
(remhash 'color my-hash-table)
```

The function `MAPHASH` allows you to iterate over all entries in the hash table.

-   Its first argument must be a function which accepts two arguments, the key and the value of each entry
-   Note that due to the nature of hash tables you can't control the order in which the entries are provided to `MAPHASH` (or other traversing constructs)

```lisp
(maphash #'(lambda (key value)
	     (format t "~A = ~A~%" key value))
	 my-hash-table)  			;; Returns COLOR = RED, as there is only one item (COLOR) in the hash table
```


<a id="orge20b38c"></a>

## Structures
Common Lisp provides the `DEFSTRUCT` facility for creating data structures with named components. This makes it easier to manipulate custom data objects as we can refer to their components by name.
Constructor, access and assignment constructs are automatically defined when a data type is defined through `DEFSTRUCT`. Consider the below example of defining a data type for rectangles.

`DEFSTRUCT` defines RECTANGLE to be a structure with two fields, HEIGHT and WIDTH. The symbol RECTANGLE becomes the name of a data type and each rectangle will be of type RECTANGLE, then STRUCTURE, then ATOM and then T.
`DEFSTRUCT` will generate four associated functions:

1.  RECTANGLE-HEIGHT and RECTANGLE-WIDTH to access elements of the structure
2.  RECTANGLE-P to test whether an object is of type RECTANGLE
3.  MAKE-RECTANGLE to create rectangles
4.  COPY-RECTANGLE to create copies of rectangles

Below is an example of the above structure.

```lisp
;; Height will default to NIL while width will default to 5 

(defstruct rectangle
  (height)
  (width 5))
```

The below creates an instance of RECTANGLE:

```lisp
(defvar rectangle-1)

(setf rectangle-1
      (make-rectangle :height 10 :width 15))

(rectangle-height rectangle-1) ;; returns 10

(setf (rectangle-width rectangle-1) 20) ;; sets RECTANGLE-WIDTH of RECTANGLE-1 to 20
```


<a id="orgab67257"></a>

## Common Lisp Object System (CLOS)

Below is an example of creating two classes, one which inherits from the other. Courtesy of the [Common Lisp Cookbook](https://lispcookbook.github.io/cl-cookbook/clos.html).

```lisp
(defclass person () ;; define a class
 ((name
  :initarg :name
  :accessor name)
 (lisper
  :initform "Yes"
  :accessor lisper)))

(defvar person-1	;; create an instance
  (make-instance 'person :name "David" )) 
```

Accessor functions are used for both getting and setting.

```lisp
(name person-1) ;; DAVID
(setf (name person-1) "Tom") ;; sets name to Tom
```

`:INITFORM` is used to set default values. 

```lisp
(lisper person-1) ;; "Yes" (default), as the value of lisper was not yet set
```

Inheriting from the PERSON class.

```lisp
(defclass child (person)
  ((can-walk-p
   :initarg :can-walk-p
   :initform "No"
   :accessor can-walk-p)))
```

Inherited classes inherit the slots of their parents. CHILD will inherit LISPER from PERSON. The below will return "Yes":
```lisp
(lisper (make-instance 'child :name "Phoebe")) ;; Returns "Yes"
```

Inherited classes can also introduce new slots. CHILD introduces CAN-WLAK-P. 
```lisp
(can-walk-p (make-instance 'child)) ;; Returns "No"
```

We can add methods to classes with a combination of `DEFGENERIC` and `DEFMETHOD`. Note that Common Lisp supports multiple dispatch so that many classes can share and use the same method names.

`DEFGENERIC` establishes an entry in the method dispatch table, while `DEFMETHOD` allows us to create specialised versions.

```lisp
(defgeneric greet (obj) ;; Version with a default method (to be used if no other specialisations exist:
  (:documentation "Says hi")
  (:method (obj)
	   (format t "Hi")))

(defgeneric greet-2 (obj1 obj2) ;; Version without default method:
  (:documentation "Says hi"))
```

In creating specialised methods, we add the parameter type to the parameter list. In a method call, LISP will then use the method which matches the parameter types of the parameters supplied in the method call.

In the below, GUEST-NAME is a parameter of type PERSON, while MESSAGE is a parameter that is not specialised and can be anything.

```lisp
(defmethod greet-2 ((guest-name person) message)
  (format t "The person greets ~A and says ~A" guest-name message))
```

Finally, it is useful to create custom print output for CLOS objects. This can be achieved with the following.

```lisp
  (defmethod print-object ((obj person) stream)
  (print-unreadable-object (obj stream :type t)
			   (format stream "~a" (name obj))))

  (print person-1) ;; Returns #<Person Tom>
```
<a id="orge334e2e"></a>
# Other
<a id="org5926aaf"></a>

## Reading & Writing to Files

`WITH-OPEN-FILE` - macro is used to read and write to files. Below is an example of opening a file and then reading from it. The `NIL` in the below inhibits end of file errors.

```lisp
(with-open-file (my-stream "/Users/ashokkhanna/test.txt")
  (format t "~a~%" (read-line my-stream nil)))
```

Below is an example of opening a file and then writing to it.
```lisp
(with-open-file (my-stream "/Users/ashokkhanna/test.txt" :direction
			   :output :if-exists :append)
  (format my-stream "~a~%" "Hello, World!"))
```

The following open arguments can be supplied to the `WITH-OPEN-FILE` macro:

| Arguments                  | Effect                             |
|-------------------------- |---------------------------------- |
| :direction :output         | Write to a file insead of reading  |
| :if-does-not-exist :create | Create a file if it does not exist |
| :if-exists :supersede      | Replace the file that exists       |
| :if-exists :overwrite      | Overwrite file                     |
| :if-exists :append         | Write to end of file               |


<a id="orgc750fcf"></a>

## Packages

Packages are a central mechanism for avoiding name collisions that occur if multiple files contain variables or functions with the same name. More information on packages can be found on [my guide on Medium](https://ashok-khanna.medium.com/an-introduction-to-lisp-packages-7a9ee352006e).

Packages need to be registered before they can be used. Below is an example of registering a package that inherits from two packages and exports two symbols. This example also shadows two symbols, allowing us to use, within MY-PACKAGE, the definitions of these symbols (RESTART and CONDITION in our case) that exist within the package MY-PACKAGE and not definitions of these symbols inherited from other packages (CL in our case, where RESTART and CONDITION are interned also).

```lisp
(defpackage :my-package
  (:use :cl :other-package-1)
  (:export :symbol-1
	   :restart)
  (:shadow :restart
	   :condition))
```

Once a package is registered with the above, we can switch to it with `IN-PACKAGE`.
-   **Within a package**, all symbols defined in that package are accessible. In addition, any exported symbols from packages inherited via the `:USE` command can be directly accessed without a package qualifier
-   **Outside of a package**, internal symbols can be accessed via a double-colon package qualifier, e.g. `my-package::symbol-3`, while exported symbols can be accessed via a single-colon package qualifier, e.g. `my-package:symbol-1`

It is good practice to put the above at the top of LISP files so that readers can easily follow which package is currently live in a file.

```lisp
(in-package :my-package)
```

We will get an error if we try to inherit from both CL and MY-PACKAGE due to to the clash in symbols RESTART and CONDITION that appear in both packages. To overcome this, we can use `:shading-import-from:`:

```lisp
(defpackage :my-package-2
  (:use :cl :my-package)
  (:shadowing-import-from :my-package :restart))
```
