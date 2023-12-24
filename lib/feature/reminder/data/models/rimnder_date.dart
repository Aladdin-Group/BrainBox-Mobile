enum ReminderDate {
  every5Minutes('Every 5 minutes',0,5),
  every50Minutes('Every 50 minutes',1,50),
  everyOneHour('Every hour',2,120),
  everyThreeHour('Every 3 hours',3,180);
  // custom('Custom',4,10);

  static ReminderDate getValue(int i){
    return ReminderDate.values[i];
  }

  const ReminderDate(this.label,this.position,this.everyTime);
  final String label;
  final int position;
  final int everyTime;
}
