#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РазрешеноРедактированиеЦенДокументов = УправлениеНебольшойФирмойУправлениеДоступомПовтИсп.РазрешеноРедактированиеЦенДокументов();
	ЭтаФорма.ТолькоПросмотр = НЕ РазрешеноРедактированиеЦенДокументов;

КонецПроцедуры

#КонецОбласти