CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

if [[ -f student/ListExamples.java ]]
then
    cp student/ListExamples.java grading/
    cp TestListExamples.java grading/
else
    echo "Missing student/ListExamples.java, did you forget the file or misname it?"
    exit 1 #nonzero exit code to follow convention
fi

pwd
cd grading
pwd

# what's the classpath argument going to be?
# /home/list-examples-grader/grader/../lib/*.jar refers to the jars
CPATH='.:../lib/hamcrest-core-1.3.jar:../lib/junit-4.13.2.jar'
javac -cp $CPATH *.java

if [[ $? -ne 0 ]]
then
  echo "The program failed to compile, see compile error above"
  exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt

lastline=$(cat junit-output.txt | tail -n 2 | head -n 1)
tests=$(echo $lastline | awk -F'[, ]' '{print $3}')
failures=$(echo $lastline | awk -F'[, ]' '{print $6}')
successes=$((tests - failures))

echo "Your score is $successes / $tests"



