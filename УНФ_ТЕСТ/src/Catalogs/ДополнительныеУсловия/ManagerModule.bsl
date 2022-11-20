#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьТиповыеУсловия() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДополнительныеУсловия.Ссылка
	|ИЗ
	|	Справочник.ДополнительныеУсловия КАК ДополнительныеУсловия
	|ГДЕ
	|	ДополнительныеУсловия.ИмяМакета = ""ТиповыеУсловия""";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ТиповыеУсловия = Выборка.Ссылка;
	Иначе
		ТиповыеУсловия = Справочники.ДополнительныеУсловия.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ТиповыеУсловия;
	
КонецФункции

Процедура ЗаполнениеТиповыхДополнительныхУсловий() Экспорт

	ТиповыеМакеты = Новый Структура;
	МетаданныеМакеты = Метаданные.Справочники.ДополнительныеУсловия.Макеты;
	Для Каждого МетаМакета Из МетаданныеМакеты Цикл
		ТиповыеМакеты.Вставить(МетаМакета.Имя, МетаМакета);
	КонецЦикла;

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДополнительныеУсловия.ИмяМакета
	|ИЗ
	|	Справочник.ДополнительныеУсловия КАК ДополнительныеУсловия
	|ГДЕ
	|	ДополнительныеУсловия.ИмяМакета <> """"";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
	
		Если ТиповыеМакеты.Свойство(Выборка.ИмяМакета) Тогда
			// Второй раз не добавляем
			ТиповыеМакеты.Удалить(Выборка.ИмяМакета);
		КонецЕсли;
	
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из ТиповыеМакеты Цикл
	
		Попытка
		
			ДополнительныеУсловияОбъект = Справочники.ДополнительныеУсловия.СоздатьЭлемент();
			ДополнительныеУсловияОбъект.Наименование 	= КлючИЗначение.Значение.Синоним;
			ДополнительныеУсловияОбъект.ИмяМакета		= КлючИЗначение.Ключ;
			
			Макет = Справочники.ДополнительныеУсловия.ПолучитьМакет(КлючИЗначение.Ключ);
			ДополнительныеУсловияОбъект.ТекстУсловий = Макет.ПолучитьТекст();
			
			ДополнительныеУсловияОбъект.Записать();
			
		Исключение
	
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось создать дополнительные условия: %1 по причине:
					|%2'"),
					КлючИЗначение.Ключ, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.Справочники.ДополнительныеУсловия, ТекстСообщения);
				
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
