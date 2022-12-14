#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НезапланированныеЗатратыВключатьВСчет Тогда
		ПроверяемыеРеквизиты.Добавить("НезапланированныеЗатратыПредставлениеВСчете");
		
		Если НезапланированныеЗатратыФормированиеЦены = Перечисления.БиллингФормированиеЦеныЗатрат.ФиксированноеЗначение Тогда
			ПроверяемыеРеквизиты.Добавить("НезапланированныеЗатратыФиксированнаяЦена");
		ИначеЕсли НезапланированныеЗатратыФормированиеЦены = Перечисления.БиллингФормированиеЦеныЗатрат.ПоСебестоимостиСНаценкой Тогда
			ПроверяемыеРеквизиты.Добавить("НезапланированныеЗатратыНаценка");
		КонецЕсли;
	КонецЕсли;
	
	Для каждого Стр Из УчетНоменклатуры Цикл
		Если Стр.ФормированиеЦены = Перечисления.БиллингФормированиеЦеныНоменклатуры.ФиксированноеЗначение
			И НЕ ЗначениеЗаполнено(Стр.Цена) Тогда
			
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Не заполнена колонка ""Цена"" в строке %1 списка ""Номенклатура"".'"),
				Стр.НомерСтроки
			);
			
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"УчетНоменклатуры",
				Стр.НомерСтроки,
				"ПредставлениеЦены",
				Отказ
			);
		КонецЕсли;
	КонецЦикла;
	
	Для каждого Стр Из УчетЗатрат Цикл
		
		Если Стр.ФормированиеЦены = Перечисления.БиллингФормированиеЦеныЗатрат.ФиксированноеЗначение
			И НЕ ЗначениеЗаполнено(Стр.Цена) Тогда
			
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Не заполнена колонка ""Цена"" в строке %1 списка ""Затраты"".'"),
				Стр.НомерСтроки
			);
			
			УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"УчетЗатрат",
				Стр.НомерСтроки,
				"ПредставлениеЦены",
				Отказ
			);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли