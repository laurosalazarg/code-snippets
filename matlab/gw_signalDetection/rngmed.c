/*---------------------------------
Mex File to compute running median in an efficient manner.
inputs:
      data (array)
      nblock (int): block size for computing median
      [optional] firstblk (array): Indices of the first nblock points post-sorting.
output:
      out (array): containing running median (same size as data).
      [optional] lastblk (array): Indices of the last nblock points post-sorting.
Soumya D. Mohanty, AEI, May 2001
** Added optional input & output arguments Aug 2001. These should allow
   the code to be used in a continuous manner in the time domain.
-----------------------------------*/

#include "mex.h"
#include <stdlib.h>
#include <math.h>

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray* prhs[]){

    double *data;
    int nblocks, lendata;
    double *medians, *block;
    mxArray *for_sort, *from_sort[2];
    double *sorted_indices, *sorted_block;
/*----------------------------------
    Two types of pointers:
         (a)next_sorted: point to the next node in sorted list
         (b)next_sequence: point to the next node in sequential list
------------------------------------*/
     struct node{
           double data;
           struct node *next_sorted, *next_sequence, *prev_sorted;
           int rank; /*Used for constructing optional output*/
     };

/*----------------------------------
checks: Array to hold pointers to Checkpoint nodes.
first_sequence: Pointer to first node of sequential list
------------------------------------*/
     struct node **checks,**node_addresses;    
     struct node *first_sequence,*last_sequence;
     struct node *currentnode,*previousnode; 
     struct node *leftnode, *rightnode;
     struct node *reuse_next_sorted,*reuse_prev_sorted;
     struct node *dummy_node,*dummy_node1,*dummy_node2;
     int ncheckpts,stepchkpts;
     int nextchkptindx,*checks4shift;
     int nearestchk,midpoint,offset,numberoffsets;
     int samplecount,k,counter_chkpt,chkcount,shiftcounter;
     double nextsample,deletesample,dummy,*dummy_array;
     int shift,dummy_int;

/*----------------------------------
Get pointer to input data.
------------------------------------*/
     data=mxGetPr(prhs[0]);
     lendata=mxGetNumberOfElements(prhs[0]);
     nblocks=*(mxGetPr(prhs[1]));
     
/*----------------------------------
Check for optional input argument
-----------------------------------*/
if (nrhs>2){
   /*initial sorted block supplied*/
   /*Check for correct size*/
   if(mxGetNumberOfElements(prhs[2])!=nblocks){
       mexErrMsgTxt("Optional argument of incorrect size");
   }
   sorted_indices=mxGetPr(prhs[2]);
   for(k=0;k<nblocks;k++){
       sorted_indices[k]-=1;
   }
}
else {
/*-----------------------------------
  Sort the first block of nblocks samples
  using the MATLAB sort function
------------------------------------*/
     for_sort=mxCreateDoubleMatrix(1,nblocks,mxREAL);
     block=mxGetPr(for_sort);
     for(k=0;k<nblocks;k++){
          block[k]=data[k];
     }
     if(mexCallMATLAB(2,from_sort,1,&for_sort,"sort")){
          mexErrMsgTxt("Could not call sort \n");
     }
     sorted_indices=mxGetPr(from_sort[1]);
     for(k=0;k<nblocks;k++){
          sorted_indices[k]-=1;
     }
     mxDestroyArray(for_sort);
}

/*----------------------------------
Indices of checkpoint nodes.
Number of nodes per checkpoint=floor(sqrt(nblocks))
------------------------------------*/
     stepchkpts=sqrt(nblocks);
     ncheckpts=nblocks/stepchkpts;
     checks=(struct node **)mxCalloc(ncheckpts,sizeof(struct node*));
     if(!checks){
           mexErrMsgTxt("Could not allocate storage for checks\n");
     }
     if(!(checks4shift=(int*)mxCalloc(ncheckpts,sizeof(int)))){
           mexErrMsgTxt("Could not allocate storage for checks4shift\n");
     }

/*---------------------------------
  Offsets for getting median from nearest
  checkpoint: For nblocks even, 
  (node(offset(1))+node(offset(2)))/2;
  for nblocks odd,
  (node(offset(1))+node(offset(1)))/2;
 ----------------------------------*/
     if((int)fmod(nblocks,2.0)){
    /*Odd*/
           midpoint=(nblocks+1)/2-1;
           numberoffsets=1;
     }
     else{
    /*Even*/
           midpoint=nblocks/2-1;
           numberoffsets=2;   
     }
     nearestchk=floor(midpoint/stepchkpts);
     offset=midpoint-nearestchk*stepchkpts;

/*----------------------------------
Build up linked list using first nblock points
in sequential order
------------------------------------*/
     node_addresses=(struct node **)mxCalloc(nblocks,sizeof(struct node *));
     if(!node_addresses){
           mexErrMsgTxt("Could not allocate storage for node_addresses\n");
     }
     first_sequence=(struct node *)mxCalloc(1,sizeof(struct node));
     if(!first_sequence){
           mexErrMsgTxt("Could not create first node\n");
     }
     node_addresses[0]=first_sequence;
     first_sequence->next_sequence=NULL;
     first_sequence->next_sorted=NULL;
     first_sequence->prev_sorted=NULL;
     first_sequence->data=data[0];
     previousnode=first_sequence;
     for(samplecount=1;samplecount<nblocks;samplecount++){
           currentnode=(struct node *)mxCalloc(1,sizeof(struct node));
           if(!currentnode){
                mexErrMsgTxt("Could not create node ");
           }
           node_addresses[samplecount]=currentnode;
           previousnode->next_sequence=currentnode;
           currentnode->next_sequence=NULL;
           currentnode->prev_sorted=NULL;
           currentnode->next_sorted=NULL;
           currentnode->data=data[samplecount];
           previousnode=currentnode;
     }
     last_sequence=currentnode;

/*------------------------------------
Set the sorted sequence pointers and
the pointers to checkpoint nodes
-------------------------------------*/
     currentnode=node_addresses[(int)sorted_indices[0]];
     previousnode=NULL;
     checks[0]=currentnode;
     nextchkptindx=stepchkpts;
     counter_chkpt=1;
     for(samplecount=1;samplecount<nblocks;samplecount++){
          dummy_node=node_addresses[(int)sorted_indices[samplecount]];
          currentnode->next_sorted=dummy_node;
          currentnode->prev_sorted=previousnode;
          previousnode=currentnode;
          currentnode=dummy_node;
          if(samplecount==nextchkptindx && counter_chkpt<ncheckpts){
                checks[counter_chkpt]=currentnode;
                nextchkptindx+=stepchkpts;
                counter_chkpt++;
          }
     }
     currentnode->prev_sorted=previousnode;
     currentnode->next_sorted=NULL;
     mxDestroyArray(from_sort[0]);
     mxDestroyArray(from_sort[1]);

/*------------------------------
  Allocate storage for output
  and get the first output element
-------------------------------*/
     medians=(double *)mxCalloc(lendata-nblocks+1,sizeof(double));
     if(!medians){
           mexErrMsgTxt("Could not allocate storage for medians");
     }
     currentnode=checks[nearestchk];
     for(k=1;k<=offset;k++){
           currentnode=currentnode->next_sorted;
     }
     dummy=0;
     for(k=1;k<=numberoffsets;k++){
           dummy+=currentnode->data;
           currentnode=currentnode->next_sorted;
     }
     medians[0]=dummy/numberoffsets;

/*---------------------------------
This is the main part
----------------------------------*/
     for(samplecount=nblocks;samplecount<lendata;samplecount++){
          nextsample=data[samplecount];
          if(nextsample>checks[0]->data){
                  for(chkcount=1;chkcount<ncheckpts;chkcount++){
                          if(nextsample>checks[chkcount]->data){
                          }
                          else{
                               break;
                          }
                  }
                  chkcount-=1;
                  rightnode=checks[chkcount];
                  while(rightnode){
                          if(nextsample<=rightnode->data){
                                break;
                          }
                          leftnode=rightnode;
                          rightnode=rightnode->next_sorted;
                  }
   /*-------------------------
     Guard against case when node to
     be deleted is currentnode, otherwise
     the inserted node will point to 
     itself
   ---------------------------*/
                  if(rightnode==first_sequence){
                          rightnode->data=nextsample;
                          first_sequence=first_sequence->next_sequence;
                          rightnode->next_sequence=NULL;
                          last_sequence->next_sequence=rightnode;
                          last_sequence=rightnode;
                          shift=0;
                  }
                  else{ 
                          if(leftnode==first_sequence){
                                 leftnode->data=nextsample;
                                 first_sequence=first_sequence->next_sequence;
                                 leftnode->next_sequence=NULL;
                                 last_sequence->next_sequence=leftnode;
                                 last_sequence=leftnode;
                                 shift=0; 
                          }
                          else {
                                 reuse_next_sorted=rightnode;
                                 reuse_prev_sorted=leftnode;
                                 shift=1; /*shift maybe required*/
                          }
                  }
          }
          else{  
                  chkcount=0;
                  dummy_node=checks[0];
                  if(dummy_node==first_sequence){
                        dummy_node->data=nextsample;
                        first_sequence=first_sequence->next_sequence;
                        dummy_node->next_sequence=NULL;
                        last_sequence->next_sequence=dummy_node;
                        last_sequence=dummy_node;
                        shift=0;
                  }
                  else{
                        reuse_next_sorted=checks[0];
                        reuse_prev_sorted=NULL;
                        shift=1;  /*shift maybe required*/
                  }
                  rightnode=checks[0];
                  leftnode=NULL;
          }

/*-----------------------------------
   Getting check points to be shifted
 -----------------------------------*/
          if(shift){
                  deletesample=first_sequence->data;
                  if(deletesample>nextsample){
                       shiftcounter=0;
                       for(k=chkcount;k<ncheckpts;k++){
                             dummy_node=checks[k];
                             dummy=dummy_node->data;
                             if(dummy>=nextsample){
                                   if(dummy<=deletesample){
                                         checks4shift[shiftcounter]=k;
                                         shiftcounter++;
                                   }
                                   else{
                                         break;
                                   }
                             }
                        }
                        shift=-1; /*Left shift*/
                  }
                  else 
                        if(deletesample<nextsample){
                              shiftcounter=0;
                              for(k=chkcount;k>=0;k--){
                                    dummy_node=checks[k];
                                    dummy=dummy_node->data;
                                    if(dummy>=deletesample){
                                         checks4shift[shiftcounter]=k;
                                         shiftcounter++;
                                    }
                                    else{
                                         break;
                                    }
                              }
                              shift=1; /* Shift Right*/
                       }
                       else{
                              mexErrMsgTxt("deletesample=nextsample for shift!=0\n");
                       }
          }

 /*------------------------------
  Delete and Insert
 --------------------------------*/
          if(shift){
                  dummy_node=first_sequence;
                  first_sequence=dummy_node->next_sequence;
                  dummy_node->next_sequence=NULL;
                  last_sequence->next_sequence=dummy_node;
                  last_sequence=dummy_node;
                  dummy_node->data=nextsample;
                  dummy_node1=dummy_node->prev_sorted;
                  dummy_node2=dummy_node->next_sorted;

   /*-----------------------
     Repair deletion point
   ------------------------*/
                 if(!dummy_node1){
                        dummy_node2->prev_sorted=dummy_node1;
                 }
                 else {
                        if(!dummy_node2){
                               dummy_node1->next_sorted=dummy_node2;
                        }
                        else{
                               dummy_node1->next_sorted=dummy_node2;
                               dummy_node2->prev_sorted=dummy_node1;
                        }
                 }  
 
   /*------------------------
     Set pointers from neighbours to new node at insertion point
   -------------------------*/
                if(!rightnode){
                       leftnode->next_sorted=dummy_node;
                }
                else {
                       if(!leftnode){
                               rightnode->prev_sorted=dummy_node;
                       }
                       else{
                               leftnode->next_sorted=dummy_node;
                               rightnode->prev_sorted=dummy_node;
                       }
                }
 
   /*-------------------------------
     Shift check points before resetting sorted list
   --------------------------------*/
               if(shift==-1){
                      for(k=0;k<shiftcounter;k++){
                              dummy_int=checks4shift[k];
                              checks[dummy_int]=checks[dummy_int]->prev_sorted;
                      }
               }
               else
                      if(shift==1){
                              for(k=0;k<shiftcounter;k++){
                                     dummy_int=checks4shift[k];
                                     checks[dummy_int]=checks[dummy_int]->next_sorted;
                              } 
                      }

  /*--------------------------------
    insert node
   --------------------------------*/
              dummy_node->next_sorted=reuse_next_sorted;
              dummy_node->prev_sorted=reuse_prev_sorted;
         }

/*--------------------------------
  Get the median
---------------------------------*/
         currentnode=checks[nearestchk];
         for(k=1;k<=offset;k++){
              currentnode=currentnode->next_sorted;
         }
         dummy=0;
         for(k=1;k<=numberoffsets;k++){
              dummy+=currentnode->data;
              currentnode=currentnode->next_sorted;
         }
         medians[samplecount-nblocks+1]=dummy/numberoffsets;
     }/*Outer For Loop*/

/*--------------------------------
  Returning output back to Matlab
---------------------------------*/
     plhs[0]=mxCreateDoubleMatrix(1,lendata-nblocks+1,mxREAL);
     dummy_array=mxGetPr(plhs[0]);
     for(k=0;k<lendata-nblocks+1;k++){
              dummy_array[k]=medians[k];
     }
     /*Construct optional output if required*/
     if(nlhs>1){
        currentnode=first_sequence;
        dummy_int=1;
        while(currentnode){
            currentnode->rank=dummy_int;
            dummy_int++;
            currentnode=currentnode->next_sequence;
        }
        plhs[1]=mxCreateDoubleMatrix(1,nblocks,mxREAL);
        dummy_array=mxGetPr(plhs[1]);
        currentnode=checks[0];
        for(k=0;k<nblocks;k++){
           dummy_array[k]=currentnode->rank;
           currentnode=currentnode->next_sorted;
        }
     }
/*--------------------------------
  Clean Up
---------------------------------*/
     mxFree(medians);
     mxFree(node_addresses);
     currentnode=first_sequence;
     while(currentnode){
             previousnode=currentnode;
             currentnode=currentnode->next_sequence;
             mxFree(previousnode);
     }
     mxFree(checks);

}/*MexFunction End*/