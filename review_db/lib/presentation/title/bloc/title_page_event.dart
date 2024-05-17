import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class DetailTitleEvent extends Equatable {
  const DetailTitleEvent();
}

class LoadTitleEvent extends DetailTitleEvent {
  @override
  List<Object> get props => [];
}