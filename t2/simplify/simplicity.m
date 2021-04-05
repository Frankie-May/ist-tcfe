source = fopen ("data.log" , "r");

destiny = fopen("data.net" , "w");

C = textscan(source , "\n\nPlease enter the lowest student number in your group:\n\n\nUnits for the values: V, mA, kOhm, mS and uF\n\n\nValues:  R1 = %f64 \nR2 = %f \nR3 = %f \nR4 = %f \nR5 = %f \nR6 = %f \nR7 = %f \nVs = %f \nC = %f \nKb = %f \nKd = %f \n");

fprintf(destiny , "*Imported data from t2_datagen.py\n");
for i=1:11
	if (0<i && i<8)
		fprintf(destiny , ".param RR%d = %fk\n" , i , C{1 , i});
	endif
	if(i == 8)
		fprintf(destiny , ".param Vss = %f\n" , C{1 , i});
	endif
	if(i==9)
		fprintf(destiny , ".param Cc = %fu\n" ,C{1 , i});
	endif
	if (i == 10)
		fprintf(destiny , ".param Kb = %fk\n" ,C{1 , i});
	endif
	if(i == 11)
		fprintf(destiny , ".param Kd = %fk\n" ,C{1 , i});
	endif
endfor