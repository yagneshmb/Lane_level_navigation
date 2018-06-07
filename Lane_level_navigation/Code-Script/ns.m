function main
#declaration
PrVL1 = 0.5;
PrVL2 = 0.5;
PrVL1VL2 = 0;
PrVL2VL1 = 0;
ConditionalProb = 0;
lookup.deltaTwo = 0;
lookup.deltaTwoHalf = 0;
lookup.deltaThree = 0;
lookup.deltaThreeHalf = 0;
RightToLeft = 21;
LeftToRight = 12;
pkg load io;
data = xlsread('data1.xlsx');
numberOfRows = 234;
prevHeading = 95.16601;
currentHeading = 95.16601;
A = data(1,[1 2 3]);
prevTime = (A(1)*3600) + (A(2)*60) + A(3);
currentTime = prevTime;  
twoCount = 0; twoYesCount = 0;
twoHalfCount = 0; twoHalfYesCount = 0;
threeCount = 0; threeYesCount = 0;
threeHalfCount = 0; threeHalfYesCount = 0;

  for i = 2:219
     #printf("%d\n",i);
    prevHeading = currentHeading;
    prevTime = currentTime;
    currentDirection = data(i,:);
    currentHeading = currentDirection(:,[4]);
   #printf(" i = %d currentHeading = ",i); 
    #printf("%f\n", currentHeading);
    if(prevHeading < currentHeading)
      changeFlag = LeftToRight;
    elseif(prevHeading > currentHeading) 
       changeFlag = RightToLeft;
    else
      changeFlag = 0;       
    endif
    #printf(" i = %d changeFlag = ",i); 
    #printf("%f\n", changeFlag);
    
    
    Time1 = data(i,[1 2 3]);
    currentTime = (Time1(1)*3600) + (Time1(2)*60) + Time1(3);
    differenceTime = currentTime - prevTime;
   #printf(" i = %d differenceTime = ",i); 
    #printf("%f\n", differenceTime);
    #degree t radian;
    diffTheta = 0.017453*abs(currentHeading - prevHeading);
    #printf(" i = %d diffTheta = ",i); 
    #printf("%f\n", diffTheta);
    distanceTravelled = differenceTime*(11.11);
    #printf("distacneTravelled = %f\n", distanceTravelled);
    deltaD = sin(diffTheta)*distanceTravelled;
    #printf(" i = %d deltaD = ",i); 
    #printf("%f\n", deltaD);
    
    if((0.5/abs(deltaD))>=1)
       data(i,[6]) = 0.5;
    elseif((1/abs(deltaD))>=1)
      data(i,6) = 1;
    elseif((1.5/abs(deltaD))>=1)
      data(i,6) = 1.5;
    elseif((2/abs(deltaD))>=1)
      data(i,6) = 2;
    elseif((2.5/abs(deltaD))>=1)
      data(i,6) = 2.5;
    elseif((3/abs(deltaD))>=1)
      data(i,6) = 3;
    elseif((3.5/abs(deltaD))>=1)
      data(i,6) = 3.5;
    else
      data(i,6) = 3.5;
    endif
    
    
        
  endfor
  # fprintf('data:\n');
   #fprintf('%f\n', data);
   
  #count frequencies
 for i = 2:219
    currentRow = data(i,:);
    if(currentRow(:,6)==2)
      twoCount++;
    elseif(currentRow(:,6)==2.5)
      twoHalfCount++;
    elseif(currentRow(:,6)==3)
      threeCount++;
    elseif(currentRow(:,6)==3.5)
      threeHalfCount++;
    endif
    
    if(currentRow(:,6)==2 && currentRow(:,5)==1)
      twoYesCount++;
    elseif(currentRow(:,6)==2.5 && currentRow(:,5)==1)
      twoHalfYesCount++;
    elseif(currentRow(:,6)==3 && currentRow(:,5)==1)
      threeYesCount++;
    elseif(currentRow(:,6)>=3.5 && currentRow(:,5)==1)
      threeHalfYesCount++;
    endif
 
 endfor
#printf("twoCount = %d\n", twoCount);
#printf("twoHalfCount = %d\n", twoHalfCount);
#printf("threeCount = %d\n", threeCount);
#printf("threeHalfCount = %d\n", threeHalfCount);
#printf("twoYesCount = %d\n", twoYesCount);
#printf("twoHalfYesCount = %d\n", twoHalfYesCount);
#printf("threeYesCount = %d\n", threeYesCount);
#printf("threeHalfYesCount = %d\n", threeHalfYesCount);

 
 lookup.deltaTwo = twoYesCount/twoCount;
 lookup.deltaTwoHalf = twoHalfYesCount/twoHalfCount;
 lookup.deltaThree = threeYesCount/threeCount;
 lookup.deltaThreeHalf = threeHalfYesCount/threeHalfCount;
 
 
 #   printf("lookup.deltaTwo = %f\n", lookup.deltaTwo);
  #  printf("lookup.deltaTwoHalf = %f\n", lookup.deltaTwoHalf);
   # printf("lookup.deltaThree = %f\n", lookup.deltaThree);
    #printf("lookup.deltaThreeHalf= %f\n", lookup.deltaThreeHalf);
       
    #Now since we have the normalised data and the lookuptable we can now iterate the data and 
    #give inference.
    #look up table
    #newData = xlsread('data.xlsx');
    for i = 2:219
      currentRow = data(i,:);
     currentHeading = data(i,4);
     printf("at row %d distance normalized = %f\n",i,currentRow(:,6));
    if(currentRow(:,6)==2)
      conditionalProb = lookup.deltaTwo;
    elseif(currentRow(:,6)==2.5)
      conditionalProb = lookup.deltaTwoHalf;
    elseif(currentRow(:,6)==3)
      conditionalProb = lookup.deltaThree;
    elseif(currentRow(:,6)==3.5)
      conditionalProb = lookup.deltaThreeHalf;
    else
      conditionalProb = 0;
    endif
   # printf("conditionalProb = %f\n", conditionalProb);
    
    if(data(i-1,4) < currentHeading)
      changeFlag = 12; #left to right
    elseif(data(i-1,4) > currentHeading) 
       changeFlag = 21; #right to left
    else
      changeFlag = 0;       
    endif
    
    
    if(changeFlag == 21)
      PrVL1VL2 = conditionalProb;
      PrVL2VL1 = 0;  
    
    elseif(changeFlag == 0)
      PrVL1VL2 = 0;
      PrVL2VL1 = 0;
    else
      PrVL2VL1 = conditionalProb;
      PrVL1VL2 = 0;
    
    endif

    #printf(" i = %d PrVL1VL2 = %f\n", i,PrVL1VL2);
    #printf(" i = %d PrVL2VL1 = %f\n", i,PrVL2VL1);
    PrVL11 = PrVL1*(1-PrVL2VL1);
    PrVL22 = PrVL2*(1-PrVL1VL2);
    PrVL1 = ((PrVL1VL2*PrVL2) + PrVL11); 
    PrVL2 = ((PrVL2VL1*PrVL1) + PrVL22);
    
#    printf(" i = %d",i);
   printf("PrVL1 = %f\n",PrVL1);
   printf("PrVL2 = %f\n\n",PrVL2);
    
  if(PrVL1 > PrVL2)      
      printf("Lane 1\n");   
  elseif(PrVL2 > PrVL1)  
      printf("Lane 2\n");
  else
    printf("Lane 1\n\n");
  endif
  
  
    endfor
    
 
  
endfunction
  