CPATH=".:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar"

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

if [[ -f student-submission/ListExamples.java ]]
then 
    cp student-submission/ListExamples.java TestListExamples.java grading-area
    cp -r lib grading-area
else 
    echo "Missing Necessary Files" 
    exit 1
fi 

pwd
cd grading-area
pwd 

javac -cp $CPATH *.java 
if [ $? -ne 0 ]
then 
    echo "Compilation Error"
    exit 1
fi 

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt

echo "were here" 

lastline=$(cat junit-output.txt | tail -n 2 | head -n 1)
tests=$(echo $lastline | awk -F'[, ]' '{print $3}')
failures=$(echo $lastline | awk -F'[, ]' '{print $6}')
successes=$(($tests - $failures))

echo "Your score is $successes / $tests"


