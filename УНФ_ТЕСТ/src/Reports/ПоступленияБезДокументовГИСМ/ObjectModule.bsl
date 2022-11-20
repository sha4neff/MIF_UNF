#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура СформироватьОтчет(Результат) Экспорт

	Результат.Очистить();
	Поступления.Очистить();
	ДокументыГИСМ.Очистить();
	
	Макет = ПолучитьМакет("Макет");
	
	Если ПоступленияЗаказанныхКиЗ Тогда
		ВывестиДанныеОПоступлениях(Макет, Результат, "КиЗ");
	КонецЕсли;
	
	Если ПоступленияМаркированныхТоваров Тогда
		ВывестиДанныеОПоступлениях(Макет, Результат, "МаркированныеТовары");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВывестиДанныеОПоступлениях(Макет,
	                                Результат,
	                                ИмяНабораДанных)
	
	Если ИмяНабораДанных = "КиЗ" Тогда
		ЗаголовокНабораДанных = НСтр("ru = 'Поступления КиЗ, по которым нет уведомлений о выпуске КиЗ'");
		ПредставлениеДокументаГИЧМ = Метаданные.Документы.ЗаявкаНаВыпускКиЗГИСМ.ПредставлениеСписка;
	ИначеЕсли ИмяНабораДанных = "МаркированныеТовары" Тогда
		ЗаголовокНабораДанных = НСтр("ru = 'Поступления маркированных товаров, по которым нет уведомлений о поступлении'");
		ПредставлениеДокументаГИЧМ = Метаданные.Документы.УведомлениеОПоступленииМаркированныхТоваровГИСМ.ПредставлениеСписка;
	КонецЕсли;
	
	ВывестиОбластьБезПараметров("ПустаяСтрока", Макет, Результат);
	
	Область = Макет.ПолучитьОбласть("ЗаголовокНаборДанных");
	Область.Параметры.ТекстЗаголовка = ЗаголовокНабораДанных;
	Результат.Вывести(Область);
	
	ВывестиОбластьБезПараметров("ПустаяСтрока", Макет, Результат);
	
	Если Не ЗначениеЗаполнено(ОтборКонтрагент) Тогда
		Область = Макет.ПолучитьОбласть("ШапкаГруппировка");
		Область.Параметры.ИмяГруппировки = НСтр("ru = 'Контрагент'");
		Результат.Вывести(Область);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ОтборОрганизация) Тогда
		Область = Макет.ПолучитьОбласть("ШапкаГруппировка");
		Область.Параметры.ИмяГруппировки = НСтр("ru = 'Организация'");
		Результат.Вывести(Область);
	КонецЕсли;
	
	Область = Макет.ПолучитьОбласть("ШапкаДетали");
	Область.Параметры.ИмяДокументаГИСМ = ПредставлениеДокументаГИЧМ;
	Результат.Вывести(Область);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", ОтборОрганизация);
	Запрос.УстановитьПараметр("Контрагент", ОтборКонтрагент);
	ТекстЗапроса = "";
	ИнтеграцияГИСМПереопределяемый.ТекстЗапросаПоПроблемнымПоступлениям(
		ИмяНабораДанных, ОтборОрганизация, ОтборКонтрагент, ТекстЗапроса);
	Запрос.Текст = ТекстЗапроса;
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	УстановитьПривилегированныйРежим(Ложь);
	
	ДополнитьТаблицу(Поступления, РезультатЗапроса[4].Выгрузить(), ИмяНабораДанных);
	ДополнитьТаблицу(ДокументыГИСМ, РезультатЗапроса[5].Выгрузить(), ИмяНабораДанных);
	
	НомерСтроки = 1;
	СтруктураПоиска = ПустаяСтруктураКлючевыеПоля();
	
	ВыборкаКонтрагенты = РезультатЗапроса[3].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаКонтрагенты.Следующий() Цикл
		
		Если Не ЗначениеЗаполнено(ОтборКонтрагент) Тогда
			Область = Макет.ПолучитьОбласть("СтрокаГруппировка");
			Область.Параметры.ЗначениеГруппировки = ВыборкаКонтрагенты.Контрагент;
			Результат.Вывести(Область);
		КонецЕсли;
		
		ВыборкаОрганизации = ВыборкаКонтрагенты.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаОрганизации.Следующий() Цикл
			
			Если Не ЗначениеЗаполнено(ОтборОрганизация) Тогда
				Область = Макет.ПолучитьОбласть("СтрокаГруппировка");
				Область.Параметры.ЗначениеГруппировки = ВыборкаОрганизации.Организация;
				Результат.Вывести(Область);
			КонецЕсли;
			
			ВыборкаДетали = ВыборкаОрганизации.Выбрать();
			Пока ВыборкаДетали.Следующий() Цикл
				
				Область = Макет.ПолучитьОбласть("СтрокаДетали");
				ЗаполнитьЗначенияСвойств(Область.Параметры, ВыборкаДетали);
				Область.Параметры.НомерСтроки = НомерСтроки;
				
				ЗаполнитьЗначенияСвойств(СтруктураПоиска, ВыборкаДетали);
				
				Если ВыборкаДетали.КоличествоВДокументахПоступления = 1 Тогда
					
					НайденныеПоступления = Поступления.НайтиСтроки(СтруктураПоиска);
					Если НайденныеПоступления.Количество() > 0 Тогда
						Область.Параметры.ДанныеРасшифровкиПоступления     = НайденныеПоступления[0].ДокументПоступления;
						Область.Параметры.КоличествоВДокументахПоступления = НайденныеПоступления[0].ДокументПоступления;
					КонецЕсли;
					
				ИначеЕсли ВыборкаДетали.КоличествоВДокументахПоступления > 1 Тогда
					
					РасшифровкаПоступления = ПустаяСтруктураКлючевыеПоля();
					РасшифровкаПоступления.Вставить("ИмяНабораДанных", ИмяНабораДанных);
					ЗаполнитьЗначенияСвойств(РасшифровкаПоступления, СтруктураПоиска);
					Область.Параметры.ДанныеРасшифровкиПоступления     = РасшифровкаПоступления;
					Область.Параметры.КоличествоВДокументахПоступления = СтрШаблон(НСтр("ru = 'Документов поступления - %1'"),
					                                                               ВыборкаДетали.КоличествоВДокументахПоступления);
					
				Иначе
					
					Область.Параметры.ДанныеРасшифровкиПоступления = Неопределено;
					
				КонецЕсли;
				
				Если ВыборкаДетали.КоличествоВДокументахГИСМ = 1 Тогда
					
					НайденныеДокументыГИСМ = ДокументыГИСМ.НайтиСтроки(СтруктураПоиска);
					Если НайденныеПоступления.Количество() > 0 Тогда
						Область.Параметры.ДанныеРасшифровкиДокументыГИСМ = НайденныеДокументыГИСМ[0].ДокументГИСМ;
						Область.Параметры.КоличествоВДокументахГИСМ      = НайденныеДокументыГИСМ[0].ДокументГИСМ;
					КонецЕсли;
					
				ИначеЕсли ВыборкаДетали.КоличествоВДокументахГИСМ > 1 Тогда
					
					РасшифровкаДокументыГИСМ = ПустаяСтруктураКлючевыеПоля();
					РасшифровкаПоступления.Вставить("ИмяНабораДанных", ИмяНабораДанных);
					ЗаполнитьЗначенияСвойств(РасшифровкаДокументыГИСМ, СтруктураПоиска);
					Область.Параметры.ДанныеРасшифровкиДокументыГИСМ = РасшифровкаДокументыГИСМ;
					Область.Параметры.КоличествоВДокументахГИСМ      = СтрШаблон(НСтр("ru = 'Документов уведомлений - %1'"),
					                                                             ВыборкаДетали.КоличествоВДокументахГИСМ);
					
				Иначе
					
					Область.Параметры.ДанныеРасшифровкиДокументыГИСМ = Неопределено;
					
				КонецЕсли;
				
				Результат.Вывести(Область);
				
				НомерСтроки = НомерСтроки + 1;
				
			КонецЦикла;
		
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПустаяСтруктураКлючевыеПоля()
	
	Возврат Новый Структура("НомерКиз, Контрагент, Организация");
	
КонецФункции

Процедура ДополнитьТаблицу(ТаблицаПриемник, ТаблицаИсточник, ИмяНабораДанных)

	Для Каждого СтрокаТаблицы Из ТаблицаИсточник Цикл
		НоваяСтрока = ТаблицаПриемник.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
		НоваяСтрока.ИмяНабораДанных = ИмяНабораДанных;
	КонецЦикла;

КонецПроцедуры

Процедура ВывестиОбластьБезПараметров(ИмяОбласти,Макет,ТаблицаОтчета)

	Область = Макет.ПолучитьОбласть(ИмяОбласти);
	ТаблицаОтчета.Вывести(Область);

КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли