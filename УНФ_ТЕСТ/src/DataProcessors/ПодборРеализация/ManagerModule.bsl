#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция возвращает структуру с параметрами обработки подбора
//
// Используется для кеширования
//
Процедура СтруктураСведенийОДокументе(СтруктураПараметров) Экспорт
	
	СтруктураПараметров = Новый Структура;
	
	Для каждого РеквизитОбработки Из Метаданные.Обработки.ПодборРеализация.Реквизиты Цикл
		
		СтруктураПараметров.Вставить(РеквизитОбработки.Имя);
		
	КонецЦикла;
	
КонецПроцедуры // СтруктураПараметровПодбора()

// Возвращает структуру обязательных параметров
//
Функция СтруктураОбязательныхПараметров()
	
	Возврат Новый Структура("Дата, Организация, ТипНоменклатуры, УникальныйИдентификаторФормыВладельца", "Дата", "Организация", "Тип номенклатуры", "Уникальный идентификатор формы владельца");
	
КонецФункции // СтруктураОбязательныхПараметров()

// Проверяем минимальный уровень заполнение параметров
//
Процедура ПроверитьЗаполнениеПараметров(ПараметрыПодбора, Отказ) Экспорт
	Перем Ошибки;
	
	СтруктураОбязательныхПараметров = СтруктураОбязательныхПараметров();
	
	Для каждого ЭлементСтруктуры Из СтруктураОбязательныхПараметров Цикл
		
		ЗначениеПараметров = Неопределено;
		Если НЕ ПараметрыПодбора.Свойство(ЭлементСтруктуры.Ключ, ЗначениеПараметров) Тогда
			
			ТекстОшибки = НСтр("ru = 'Отсутствует обязательный параметр (%1), необходимый для открытия формы подбора номенклатуры.'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ЭлементСтруктуры.Значение);
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, , ТекстОшибки, Неопределено);
			
		ИначеЕсли НЕ ЗначениеЗаполнено(ЗначениеПараметров) Тогда
			
			ТекстОшибки = НСтр("ru = 'Неверно заполнен обязательный параметр (%1), необходимый для открытия формы подбора номенклатуры.'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ЭлементСтруктуры.Значение);
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, , ТекстОшибки, Неопределено);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры // ПроверитьЗаполнениеПараметров()

// Функция возвращает полное имя формы подбора 
//
Функция ПолноеИмяФормыПодбора() Экспорт
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		Возврат "Обработка.ПодборРеализация.Форма.КорзинаЦенаОстатокРезервХарактеристика_МК";
		
	Иначе
		
		Возврат "Обработка.ПодборРеализация.Форма.КорзинаЦенаОстатокРезервХарактеристика";
		
	КонецЕсли;
	
КонецФункции // ПолноеИмяФормыПодбора()

#КонецОбласти

#КонецЕсли