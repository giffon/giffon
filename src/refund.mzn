float: wish_value;
int: num_users;
set of int: USER = 1..num_users;
array[USER] of float: pledges;
array[USER] of var float: charges;
array[USER] of var float: refunds;

constraint forall(i in USER)(charges[i] > 0);
constraint forall(i in USER)(refunds[i] > 0);
constraint forall(i in USER)(charges[i] <= pledges[i]);
constraint forall(i in USER)(refunds[i] <= pledges[i]);
constraint forall(i in USER)(charges[i] + refunds[i] = pledges[i]);

constraint sum(charges) = wish_value;

constraint forall(i in USER)(wish_value / sum(pledges) = charges[i] / pledges[i]);

solve satisfy;
