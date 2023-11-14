
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class NavigationState extends Equatable{
  final int navigationIndex;
  const NavigationState({this.navigationIndex=0});
  NavigationState copyWith({int? navigationIndex}) => NavigationState(navigationIndex: navigationIndex??this.navigationIndex);

  @override
  List<Object> get props => [navigationIndex];
}

