
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьТаблицуФайловОтработанныхПакетовЭД();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтработанныеПакетыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Элементы.ОтработанныеПакеты.ТекущиеДанные.Документ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	УстановитьЗначенияФлажков(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьВсе(Команда)
	
	УстановитьЗначенияФлажков(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдалениеОтмеченныеПЭД(Команда)
	
	УдалитьДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеПоТаблицам(Команда)
	
	ЗаполнитьТаблицуФайловОтработанныхПакетовЭД();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуФайловОтработанныхПакетовЭД()
	
	ОтработанныеПакеты.Очистить();
	
	ЗапросПакетов = Новый Запрос;
	УдаляемыеСтатусыПакетов = Новый СписокЗначений;
	УдаляемыеСтатусыПакетов.Добавить(Перечисления.СтатусыПакетовЭД.Отменен);
	УдаляемыеСтатусыПакетов.Добавить(Перечисления.СтатусыПакетовЭД.Доставлен);
	УдаляемыеСтатусыПакетов.Добавить(Перечисления.СтатусыПакетовЭД.Распакован);
	УдаляемыеСтатусыПакетов.Добавить(Перечисления.СтатусыПакетовЭД.Отправлен);
	ЗапросПакетов.УстановитьПараметр("СтатусПакета", УдаляемыеСтатусыПакетов);
	
	ЗапросПакетов.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
	|	ЭДПрисоединенныеФайлы.Ссылка КАК Документ,
	|	ЭДПрисоединенныеФайлы.ВладелецФайла.СтатусПакета КАК Статус,
	|	ЛОЖЬ КАК Выбран,
	|	ЭДПрисоединенныеФайлы.ДатаСоздания КАК ДатаПолучения,
	|	ЭДПрисоединенныеФайлы.ВладелецФайла.Организация КАК Организация,
	|	ЭДПрисоединенныеФайлы.ВладелецФайла.Контрагент КАК Контрагент,
	|	ЭДПрисоединенныеФайлы.ВладелецФайла.Направление КАК Направление
	|ИЗ
	|	Справочник.ПакетЭДПрисоединенныеФайлы КАК ЭДПрисоединенныеФайлы
	|ГДЕ
	|	ЭДПрисоединенныеФайлы.ВладелецФайла ССЫЛКА Документ.ПакетЭД
	|	И ЭДПрисоединенныеФайлы.ПометкаУдаления = ЛОЖЬ
	|	И ВЫРАЗИТЬ(ЭДПрисоединенныеФайлы.ВладелецФайла КАК Документ.ПакетЭД).СтатусПакета В (&СтатусПакета)";
	
	ЗначениеВРеквизитФормы(ЗапросПакетов.Выполнить().Выгрузить(), "ОтработанныеПакеты");
	
КонецПроцедуры

&НаСервере
Процедура УдалитьДанные()
	
	Для Каждого СтрокаУдаления Из ОтработанныеПакеты Цикл
		Если СтрокаУдаления.Выбран Тогда
			НачатьТранзакцию();
			Попытка
				ОбъектУдаления = ЭлектронноеВзаимодействиеСлужебный.ОбъектПоСсылкеДляИзменения(СтрокаУдаления.Документ);
				ОбъектУдаления.ПометкаУдаления = Истина;
				ОбъектУдаления.Записать();
				ЗафиксироватьТранзакцию();
			Исключение
				ОтменитьТранзакцию();
				ВызватьИсключение;
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	
	ЗаполнитьТаблицуФайловОтработанныхПакетовЭД();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияФлажков(ПараметрУстановки)
	
	Для Каждого Строка Из ОтработанныеПакеты Цикл
		Строка.Выбран = ПараметрУстановки;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
