#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Параметры.СформироватьПриОткрытии = Истина;
	Отчет.Период = Параметры.Период;
	УстановитьТекущийВариант(Параметры.ВидОтчета);

	Если ЗначениеЗаполнено(Параметры.Организация) Тогда
		Организация = Параметры.Организация;
	Иначе
		Организация = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
			Пользователи.ТекущийПользователь(), "ОсновнаяОрганизация");
		Если Не ЗначениеЗаполнено(Организация) Тогда
			Организация = УправлениеНебольшойФирмойСервер.ПолучитьПредопределеннуюОрганизацию();
		КонецЕсли;
	КонецЕсли;
	УправлениеНебольшойФирмойОтчеты.УстановитьЗначениеПользовательскойНастройки(Отчет.КомпоновщикНастроек,
		"Организация", Организация);
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	УправлениеНебольшойФирмойОтчеты.УстановитьЗначениеПользовательскойНастройки(Отчет.КомпоновщикНастроек,
		"Организация", Организация);
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	УправлениеНебольшойФирмойОтчеты.УстановитьЗначениеПользовательскойНастройки(Отчет.КомпоновщикНастроек,
		"Организация", Организация);
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	УправлениеНебольшойФирмойОтчеты.УстановитьЗначениеПользовательскойНастройки(Отчет.КомпоновщикНастроек,
		"Организация", Организация);
КонецПроцедуры

#КонецОбласти
