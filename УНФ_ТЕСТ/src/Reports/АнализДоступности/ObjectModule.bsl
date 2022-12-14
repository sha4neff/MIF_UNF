#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиОтчета.ПоказыватьНастройкиДиаграммыНаФормеОтчета = Ложь;
	
	НастройкиВариантов["Основной"].Вставить("РежимПериода", "НаДату");
	НастройкиВариантов["Основной"].Теги = НСтр("ru = 'Продажи,Закупки,Запасы,Работы,Производство,Номенклатура'");
	НастройкиВариантов["Основной"].Рекомендуемый = Истина;
	НастройкиВариантов["Основной"].Вставить("ФиксироватьКолонки", Истина);
	
	НастройкиВариантов["СвободныеОстаткиКонтекст"].Рекомендуемый = Истина;
	
	ДобавитьОписанияСвязанныхПолей(НастройкиВариантов);
	
	Если ПолучитьФункциональнуюОпцию("РезервированиеЗапасов") Тогда
		ВключитьГруппировкуПоЗаказуПокупателяРекурсивно(КомпоновщикНастроек.Настройки.Структура);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКонтекстномОткрытии(Объект, ПолеСвязи, Отборы, Отказ) Экспорт
	
	Если ПолеСвязи <> "Номенклатура" Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Объект) = Тип("ДокументСсылка.РасходнаяНакладная")
		Или ТипЗнч(Объект) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		Отборы.Вставить(ПолеСвязи, СписокНоменклатурыИзДокумента(Объект));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("РезервированиеЗапасов") Тогда
		ОграничитьИспользованиеПоля(СхемаКомпоновкиДанных, "Резерв");
		ОграничитьИспользованиеПоля(СхемаКомпоновкиДанных, "Свободно");
	КонецЕсли;
	
	ОтчетыУНФ.ПриКомпоновкеРезультата(КомпоновщикНастроек, СхемаКомпоновкиДанных, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СписокНоменклатурыИзДокумента(Документ)
	
	Результат = Документ.Запасы.ВыгрузитьКолонку("Номенклатура");
	
	Если ТипЗнч(Документ) = Тип("ДокументСсылка.ЗаказПокупателя")
		И Документ.ВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаряд Тогда
		
		Для каждого СтрокаТаблицы Из Документ.Материалы Цикл
			Результат.Добавить(СтрокаТаблицы.Номенклатура);
		КонецЦикла;
		
		Для каждого СтрокаТаблицы Из Документ.МатериалыЗаказчика Цикл
			Результат.Добавить(СтрокаТаблицы.Номенклатура);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	СтруктураВарианта = НастройкиВариантов["СвободныеОстаткиКонтекст"];
	ОтчетыУНФ.ДобавитьОписаниеПривязки(СтруктураВарианта.СвязанныеПоля, "Номенклатура", "Справочник.Номенклатура",,, Истина);
	ОтчетыУНФ.ДобавитьОписаниеПривязки(СтруктураВарианта.СвязанныеПоля, "Номенклатура", "Документ.РасходнаяНакладная",, Истина, Истина);
	ОтчетыУНФ.ДобавитьОписаниеПривязки(СтруктураВарианта.СвязанныеПоля, "Номенклатура", "Документ.ЗаказПокупателя",, Истина, Истина);
	
КонецПроцедуры

Процедура ОграничитьИспользованиеПоля(СхемаКомпоновкиДанных, ИмяПоля)
	
	ПолеСКД = СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Поля.Найти(ИмяПоля);
	Если ПолеСКД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПолеСКД.ОграничениеИспользования.Группировка = Истина;
	ПолеСКД.ОграничениеИспользования.Поле = Истина;
	ПолеСКД.ОграничениеИспользования.Порядок = Истина;
	ПолеСКД.ОграничениеИспользования.Условие = Истина;
	
КонецПроцедуры

Процедура ВключитьГруппировкуПоЗаказуПокупателяРекурсивно(СтруктураНастроекКД)
	
	Для Каждого ТекЭлемент Из СтруктураНастроекКД Цикл
		
		Если ТипЗнч(ТекЭлемент) = Тип("ТаблицаКомпоновкиДанных") Тогда
			Для Каждого ТекГруппировка Из ТекЭлемент.Строки Цикл
				ВключитьГруппировкуПоЗаказуПокупателя(ТекГруппировка);
			КонецЦикла;
		ИначеЕсли ТипЗнч(ТекЭлемент) = Тип("ГруппировкаТаблицыКомпоновкиДанных") Тогда
			ВключитьГруппировкуПоЗаказуПокупателя(ТекЭлемент);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ВключитьГруппировкуПоЗаказуПокупателя(Знач ТекГруппировка)
	
	Для Каждого ТекПолеГруппировки Из ТекГруппировка.ПоляГруппировки.Элементы Цикл
		Если ТекПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("ЗаказПокупателя") Тогда
			ТекГруппировка.Использование = Истина;
		КонецЕсли;
	КонецЦикла;
	
	ВключитьГруппировкуПоЗаказуПокупателяРекурсивно(ТекГруппировка.Структура)
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ЭтоОтчетУНФ = Истина;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли