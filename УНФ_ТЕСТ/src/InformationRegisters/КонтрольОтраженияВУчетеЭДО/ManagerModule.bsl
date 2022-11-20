#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ОбновлениеВерсииИБ

// Регистрирует данные для обработчика обновления
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Ложь;
	ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрСведений.КонтрольОтраженияВУчетеЭДО";
	ДополнительныеПараметры.ОтметитьВсеРегистраторы = Ложь;
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	
	Данные = ДанныеКОбработкеДляПереходаНаНовуюВерсию();
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Данные, ДополнительныеПараметры);
	
КонецПроцедуры

// Обработчик обновления.
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ИнициализироватьПараметрыОбработкиДляПереходаНаНовуюВерсию(Параметры);
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.КонтрольОтраженияВУчетеЭДО;
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	
	ОбработанныхОбъектов = 0;
	ПроблемныхОбъектов = 0;
	
	ОбработатьДанные_НачальноеЗаполнение(Параметры, ОбработанныхОбъектов, ПроблемныхОбъектов);
	
	Если ОбработанныхОбъектов = 0 И ПроблемныхОбъектов <> 0 Тогда
		ШаблонСообщения = НСтр("ru = 'Не удалось обработать контроль отражения в учете электронных документов (пропущены): %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ШаблонСообщения = НСтр("ru = 'Обработана очередная порция контроля отражения в учете электронных документов: %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ОбработанныхОбъектов);
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			МетаданныеОбъекта,, ТекстСообщения);
	КонецЕсли;
	
	Параметры.ПрогрессВыполнения.ОбработаноОбъектов  = Параметры.ПрогрессВыполнения.ОбработаноОбъектов + ОбработанныхОбъектов;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта)
		И Параметры.НачальноеЗаполнение.ОбработкаЗавершена;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Обновление

Процедура ИнициализироватьПараметрыОбработкиДляПереходаНаНовуюВерсию(Параметры)
	
	// Добавим параметры начального заполнения.
	Если Не Параметры.Свойство("НачальноеЗаполнение") Тогда
		
		ПараметрыНачальногоЗаполнения = Новый Структура;
		Выборка = ВыбратьЭлектронныеДокументыДляНачальногоЗаполнения();
		КоличествоОбъектов = Выборка.Количество();
		ПараметрыНачальногоЗаполнения.Вставить("ВсегоОбъектов", КоличествоОбъектов);
		ПараметрыНачальногоЗаполнения.Вставить("ОбработкаЗавершена", (КоличествоОбъектов = 0));
		Параметры.Вставить("НачальноеЗаполнение", ПараметрыНачальногоЗаполнения);
		
	КонецЕсли;
	
	// Определим общее количество объектов к обработке.
	Если Параметры.ПрогрессВыполнения.ВсегоОбъектов = 0 Тогда
		
		Параметры.ПрогрессВыполнения.ВсегоОбъектов = Параметры.НачальноеЗаполнение.ВсегоОбъектов;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ДанныеКОбработкеДляПереходаНаНовуюВерсию() 
	
	// При обновлении выполняется только начальное заполнение.
	Возврат Новый Массив;
	
КонецФункции

Функция ВыбратьЭлектронныеДокументыДляНачальногоЗаполнения(Знач РазмерПорции = 0)
	
	// Выбираем электронные документы не отраженные в учете
	// и отсутствующие в регистре КонтрольОтраженияВУчетеЭДО.
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1000
	|	ЭлектронныйДокументВходящий.Ссылка КАК ЭлектронныйДокумент
	|ИЗ
	|	Документ.ЭлектронныйДокументВходящий КАК ЭлектронныйДокументВходящий
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтрольОтраженияВУчетеЭДО КАК КонтрольОтраженияВУчетеЭДО
	|		ПО ЭлектронныйДокументВходящий.Ссылка = КонтрольОтраженияВУчетеЭДО.ЭлектронныйДокумент
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЭДПрисоединенныеФайлы КАК ЭДПрисоединенныеФайлы
	|		ПО ЭлектронныйДокументВходящий.Ссылка = ЭДПрисоединенныеФайлы.ВладелецФайла
	|			И (НЕ ЭлектронныйДокументВходящий.ПометкаУдаления)
	|ГДЕ
	|	НЕ ЭлектронныйДокументВходящий.СостояниеЭДО В (ЗНАЧЕНИЕ(Перечисление.СостоянияВерсийЭД.Отклонен), ЗНАЧЕНИЕ(Перечисление.СостоянияВерсийЭД.Аннулирован), ЗНАЧЕНИЕ(Перечисление.СостоянияВерсийЭД.ОжидаетсяАннулирование), ЗНАЧЕНИЕ(Перечисление.СостоянияВерсийЭД.НеСформирован), ЗНАЧЕНИЕ(Перечисление.СостоянияВерсийЭД.ЗакрытПринудительно))
	|	И НЕ ЭлектронныйДокументВходящий.ВидЭД = ЗНАЧЕНИЕ(Перечисление.ВидыЭД.ПроизвольныйЭД)
	|	И ЭДПрисоединенныеФайлы.ТипЭлементаВерсииЭД В (ЗНАЧЕНИЕ(Перечисление.ТипыЭлементовВерсииЭД.ПервичныйЭД), ЗНАЧЕНИЕ(Перечисление.ТипыЭлементовВерсииЭД.ЭСФ), ЗНАЧЕНИЕ(Перечисление.ТипыЭлементовВерсииЭД.СЧФДОПУПД), ЗНАЧЕНИЕ(Перечисление.ТипыЭлементовВерсииЭД.СЧФУПД), ЗНАЧЕНИЕ(Перечисление.ТипыЭлементовВерсииЭД.ДОПУПД), ЗНАЧЕНИЕ(Перечисление.ТипыЭлементовВерсииЭД.КСЧФДИСУКД), ЗНАЧЕНИЕ(Перечисление.ТипыЭлементовВерсииЭД.КСЧФУКД), ЗНАЧЕНИЕ(Перечисление.ТипыЭлементовВерсииЭД.ДИСУКД), ЗНАЧЕНИЕ(Перечисление.ТипыЭлементовВерсииЭД.ДОП))
	|	И НЕ 1 В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					1
	|				ИЗ
	|					Документ.ЭлектронныйДокументВходящий.ДокументыОснования КАК ЭлектронныйДокументВходящийДокументыОснования
	|				ГДЕ
	|					ЭлектронныйДокументВходящий.Ссылка = ЭлектронныйДокументВходящийДокументыОснования.Ссылка)
	|	И КонтрольОтраженияВУчетеЭДО.ЭлектронныйДокумент ЕСТЬ NULL";
	
	ТекстЗамены = ?(ЗначениеЗаполнено(РазмерПорции), "ПЕРВЫЕ " + Формат(РазмерПорции, "ЧГ=0"), "");
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПЕРВЫЕ 1000", ТекстЗамены);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат Выборка;
	
КонецФункции

Процедура ОбработатьДанные_НачальноеЗаполнение(Параметры, ОбработанныхОбъектов, ПроблемныхОбъектов)
	
	Если Параметры.НачальноеЗаполнение.ОбработкаЗавершена Тогда
		Возврат;
	КонецЕсли;
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.КонтрольОтраженияВУчетеЭДО;
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	
	Выборка = ВыбратьЭлектронныеДокументыДляНачальногоЗаполнения(1000);
	
	Если Выборка.Количество() = 0 Тогда
		Параметры.НачальноеЗаполнение.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	
	Пока Выборка.Следующий() Цикл
		
		ЭлектронныйДокумент = Выборка.ЭлектронныйДокумент;
		
		НачатьТранзакцию();
		Попытка
			
			ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭлектронныйДокумент,,
				"Документы.ЭлектронныйДокументВходящий.ОбработатьДанныеДляПереходаНаНовуюВерсию",
				"РегистрыСведений.КонтрольОтраженияВУчетеЭДО.ОбработатьДанные_НачальноеЗаполнение");
			
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("ЭлектронныйДокумент", ЭлектронныйДокумент);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			Набор = РегистрыСведений.КонтрольОтраженияВУчетеЭДО.СоздатьНаборЗаписей();
			Набор.Отбор.ЭлектронныйДокумент.Установить(ЭлектронныйДокумент);
			Набор.Прочитать();
			
			Если Не ЗначениеЗаполнено(Набор) И Не ЭлектронныйДокументОтраженВУчете(ЭлектронныйДокумент) Тогда
				
				Запись = Набор.Добавить();
				Запись.ЭлектронныйДокумент = ЭлектронныйДокумент;
				Запись.СоздатьУчетныйДокумент = Истина;
				
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(Набор);
				
			КонецЕсли;
			
			ОбработанныхОбъектов = ОбработанныхОбъектов + 1;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			ШаблонСообщения = НСтр("ru = 'Не удалось установить контроль отражения в учете электронного документа: %1 по причине:'");
			ТекстСообщения = СтрШаблон(ШаблонСообщения, ЭлектронныйДокумент) + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеОбъекта, , ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ЭлектронныйДокументОтраженВУчете(Знач ЭлектронныйДокумент)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЕстьУчетныйДокумент
	|ИЗ
	|	Документ.ЭлектронныйДокументВходящий.ДокументыОснования КАК ДокументыОснования
	|ГДЕ
	|	ДокументыОснования.Ссылка = &ЭлектронныйДокумент";
	Запрос.УстановитьПараметр("ЭлектронныйДокумент", ЭлектронныйДокумент);
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
