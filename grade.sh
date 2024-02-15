CPATH='.:../lib/hamcrest-core-1.3.jar:../lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

if [[ -f student-submission/ListExamples.java ]]
then 
    cp student-submission/ListExamples.java grading-area/
    cp TestListExamples.java grading-area/
else 
    echo "Missing ListExamples.java file."
    exit 1
fi 

cd grading-area
echo "We entered the grading-area directory"
pwd 

javac -cp $CPATH *.java


if [[ $? -ne 0 ]]
then 
    echo "The program failed to compile. Try again"
    exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt


lastline=$(cat junit-output.txt | tail -n 2)
echo $lastline > checksuccess.txt
issuccessbinary=$(grep -q "OK" checksuccess.txt)

if [[ $? -eq 0 ]]
then
    echo "THIS WAS A SUCCESSFUL TEST"
    tests=$(echo $lastline | awk -F'[( ]' '{print $3}')
    successes=$tests
else
    echo $lastline "This is the last line-----"
    tests=$(echo $lastline | awk -F'[, ]' '{print $3}')
    failures=$(echo $lastline | awk -F'[, ]' '{print $6}')
    successes=$((tests - failures))
fi

echo "Your score is $successes / $tests"
percentage=$(( successes / tests ))
if [[ percentage -eq 1 ]]
then
    echo "or 100%"
else
    percentage=$(( successes / tests * 100 ))
    echo "or $percentage%"
fi


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

