/*
 * Chris' implementation of Graham's Scan
 * Copyright (C) 2003 Chris Harrison
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */

/*
 * Adapted for C99 by Ben Brame, April 2009.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>

#define TRUE 1
#define FALSE 0

//--------------------POINT DATA STRUCTURE---------------------------
struct point
{
    int x; //X POSITION
    int y; //Y POSITION
    struct point *next; //POINTER TO NEXT NODE IN THE LIST
    struct point *prev; //POINTER TO PREVIOUS NODE IN THE LIST
    float angle; //INTERMEDIATE ANGLE VALUE STORAGE
};


//--------------------GLOBAL VARIABLES---------------------------
const int NumPoints = 50; // n<1000
struct point* firstPoint; //GLOBAL POINTER TO MIN POINT IN DOUBLELY LINKED LIST


//--------------------GRAHAM'S SCAN FUNCTIONS---------------------------
void grahamInit(); //INITIALIZE VARIABLES, RANDOMLY GENERATE POINTS,
//LOCATE MIN POINT, AND SORT POINTS BY RELATIVE ANGLES
void grahamMain(); //SETUP, RUN GRAHAM'S SCAN, AND DISPLAY RESULTS
void grahamScan(struct point *P); //ACTUAL GRAHAM'S SCAN PROCEDURE
int isConvexPoint(struct point *P); //TEST POINT FOR CONVEXITY
void addPoint(struct point Point); //ADDS POINT TO DOUBLELY LINKED LIST (USED DURING SORTING)
double findAngle(double x1, double y1, double x2, double y2); //FIND ANGLE GIVEN TWO POINTS


//--------------------AUXILARY GRAPHICS FUNCTIONS---------------------------
void drawPermeter(int color); //DRAWS PERIMETER WITH 3 COLOR POSSIBILITIES
void printPoints(); //PRINTS ALL POINTS IN DOUBLELY LINKED LIST


//--------------------MAIN---------------------------
/*
int main(int argc, char *argv[])
{
    srand(time(NULL)); //SEED THE RANDOM NUMBER GENERATER WITH THE TIME
    grahamMain(); //RUN ENTIRE GRAHAM'S SCAN PROCEDURE
    return 0; //EXIT
}
*/

void grahamMain()
{
    grahamInit(); //INITIALIZE DATA FOR GRAHAM'S SCAN
    printPoints(); //PRINT OUT SORTED POINTS
    grahamScan(firstPoint->next); //RUN GRAHAM'S SCAN STARTING AT SECOND NODE CLOCKWISE
	printf("\n\n\n");
    printPoints(); //PRINT OUT CONVEX HULL
}


void grahamScan(struct point *P)
{
    struct point *tempPrev, *tempNext;
    
    if (P==firstPoint) //IF RETURNED TO FIRST POINT, DONE
        return;
    
    if (!isConvexPoint(P)) //IF POINT IS CONCAVE, ELIMINATE FROM PERIMETER
    {
        tempPrev=P->prev;
        tempNext=P->next;
        tempPrev->next=tempNext;
        tempNext->prev=tempPrev;
        free(P); //FREE MEMORY
        grahamScan(tempPrev); //RUN GRAHAM'S SCAN ON PREVIOUS POINT TO CHECK IF CONVEXITY HAS CHANGED IT
        
    }
    else //POINT IS CONVEX
        grahamScan(P->next); //PROCEED TO NEXT POINT
}


void grahamInit()
{
    int minPoint=0;
    double tempAngle=0;
    struct point tempPoints[1000]; //CREATE STATIC ARRAY FOR RANDOM POINT GENERATION
    struct point *tempPtr;
    int i,k;
	
    firstPoint=NULL; //INIT FIRSTPOINT POINTER
    
    for (i=0;i<NumPoints;i++) //GENERATE RANDOM POINTS
    {
        tempPoints[i].x=rand()%400+50;
        tempPoints[i].y=rand()%400+50;
    }
    
    for (k=1;k<NumPoints;k++)  //FIND MIN POINT
        if (tempPoints[k].y<tempPoints[minPoint].y)
            minPoint=k;
    
    for (i=0;i<NumPoints;i++) //SORT RANDOM POINTS
    {
        tempPoints[i].angle=findAngle(tempPoints[minPoint].x,tempPoints[minPoint].y,tempPoints[i].x,tempPoints[i].y);
        addPoint(tempPoints[i]);
    }
    
    tempPtr=firstPoint;
    do  //FIND LAST NODE IN LINKED LIST
    {
        tempPtr=tempPtr->next;
    } while (tempPtr->next!=NULL);
    
    tempPtr->next=firstPoint; //COMPLETE CIRCULAR LINKED LIST
    firstPoint->prev=tempPtr; //COMPLETE CIRCULAR LINKED LIST
}

int isConvexPoint(struct point* P)
{

    double CWAngle=findAngle(P->x,P->y,P->prev->x,P->prev->y); //COMPUTE CLOCKWISE ANGLE
    double CCWAngle=findAngle(P->x,P->y,P->next->x,P->next->y); //COMPUTER COUNTERCLOCKWISE ANGLE
    double difAngle;
    
    
    if (CWAngle>CCWAngle)
    {
        difAngle=CWAngle-CCWAngle;  //COMPUTE DIFFERENCE BETWEEN THE TWO ANGLES
        
        if (difAngle>180)
            return FALSE; //POINT IS CONCAVE
        else
            return TRUE; //POINT IS CONVEX
    }
    else if (CWAngle<CCWAngle)
    {
        difAngle=CCWAngle-CWAngle;  //COMPUTE DIFFERENCE BETWEEN THE TWO ANGLES
        
        if (difAngle>180)
            return TRUE; //POINT IS CONVEX
        else
            return FALSE; //POINT IS CONCAVE
    }
    else if (CWAngle == CCWAngle)
        return FALSE; //POINT IS COLINEAR
}


void addPoint(struct point Point)
{
    struct point *tempPoint,*tempPointA,*tempPointB, *curPoint;
    
    //ALLOCATE A NEW POINT STRUCTURE AND INITIALIZE INTERNAL VARIABLES
    tempPoint = (struct point*)malloc(sizeof(struct point));
    tempPoint->x=Point.x;
    tempPoint->y=Point.y;
    tempPoint->angle=Point.angle;
    tempPoint->next=NULL;
    tempPoint->prev=NULL;
    
    
    if (firstPoint==NULL) //TEST IF LIST IS EMPTY
    {
        firstPoint=tempPoint;
        return;
    }
    
    if (firstPoint->next==NULL && tempPoint->angle >= firstPoint->angle)
        //TEST IF ONLY ONE NODE IN LIST AND CURRENT NODE HAS GREATER ANGLE
    {
        firstPoint->next=tempPoint;
        tempPoint->prev=firstPoint;
        return;
    }
    
    curPoint=firstPoint;
    
    while (tempPoint->angle >= curPoint->angle && curPoint->next!=NULL)
        //CONTINUE THROUGH LIST UNTIL A NODE IS FOUND WITH A GREATER ANGLE THAN CURRENT NODE
        curPoint=curPoint->next;
    
    if (curPoint==firstPoint) //TEST IF NODE IS FIRSTPOINT.  IF SO, ADD AT FRONT OF LIST.
    {
        firstPoint->prev=tempPoint;
        tempPoint->next=firstPoint;
        firstPoint=tempPoint;
        return;
    }
    else if (curPoint->next==NULL && tempPoint->angle >= curPoint->angle)
        //TEST IF WHILE LOOP REACHED FINAL NODE IN LIST.  IF SO, ADD AT END OF THE LIST.
    {
        curPoint->next=tempPoint;
        tempPoint->prev=curPoint;
        return;
    }
    else //OTHERWISE, INTERMEDIATE NODE HAS BEEN FOUND.  INSERT INTO LIST.
    {
        tempPointA=curPoint->prev;
        tempPointB=curPoint->prev->next;
        tempPoint->next=tempPointB;
        tempPoint->prev=tempPointA;
        tempPoint->prev->next=tempPoint;
        tempPoint->next->prev=tempPoint;
    }
    
    return;
}

double findAngle(double x1, double y1, double x2, double y2)
{
    double deltaX=(double)(x2-x1);
    double deltaY=(double)(y2-y1);
    double angle;
    
    if (deltaX==0 && deltaY==0)
        return 0;
    
    angle=atan2(deltaY,deltaX)*57.295779513082;
    
    if (angle < 0)
        angle += 360.;
    
    return angle;
}


void printPoints()
{
    struct point *curPoint=firstPoint;
    
    do
	{
		printf("angle: %f x: %d y: %d\n", curPoint->angle, curPoint->x, curPoint->y);
        curPoint=curPoint->next;
    } while (curPoint!=firstPoint); //CONTINUE UNTIL HAVING LOOPED BACK AROUND TO FIRSTPOINT
}

