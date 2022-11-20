
&НаКлиенте
Процедура КорпоративныйПроцессПриИзменении(Элемент)
	
	ОбновитьСписок();
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписок()
	Список.ТекстЗапроса=ПолучитьТекстЗапроса();
	
	Если ЗначениеЗаполнено(КорпоративныйПроцесс) Тогда
		Список.Параметры.УстановитьЗначениеПараметра("БизнесПроцесс", КорпоративныйПроцесс);
		
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьТекстЗапроса()
	
	ТекстЗапроса="
		|	ВЫБРАТЬ
		|	РегистрСведенийаДокументооборотОбработкаТочек.Период,
		|	РегистрСведенийаДокументооборотОбработкаТочек.БизнесПроцесс,
		|	РегистрСведенийаДокументооборотОбработкаТочек.ТочкаКБП,
		|	РегистрСведенийаДокументооборотОбработкаТочек.НомерПрохода,
		|	РегистрСведенийаДокументооборотОбработкаТочек.Состояние,
		|	РегистрСведенийаДокументооборотОбработкаТочек.Примечание
		|ИЗ
		|	РегистрСведений.КП_ОбработкаТочек КАК РегистрСведенийаДокументооборотОбработкаТочек
		|";
		
		
	Если ЗначениеЗаполнено(КорпоративныйПроцесс) Тогда
		ТекстЗапроса=ТекстЗапроса+" ГДЕ РегистрСведенийаДокументооборотОбработкаТочек.БизнесПроцесс=&БизнесПроцесс";
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции
