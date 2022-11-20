#Область ПрограммныйИнтерфейс

// Создает новое задание очереди заданий.
//
// Параметры
//  КодУзла - Строка - Код узла плана обмена
//  НаименованиеУзла - Строка - Наименование узла плана обмена
//  Расписание - РасписаниеРегламентногоЗадания - Расписание.
//
// Возвращаемое значение: УникальныйИдентификатор.
//
Функция СоздатьНовоеЗадание(КодУзла, НаименованиеУзла, Расписание) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Параметры = Новый Массив;
	Параметры.Добавить(КодУзла);
	
	ИдентификаторРегламентногоЗадания = Неопределено;
	
	Если Не РаботаВМоделиСервиса.РазделениеВключено() Тогда
		
		Задание = РегламентныеЗадания.СоздатьРегламентноеЗадание("ОбменССайтом");
		Задание.Использование = Истина;
		Задание.Ключ = Строка(Новый УникальныйИдентификатор);
		Задание.Наименование = НаименованиеУзла;
		Задание.Параметры = Параметры;
		Задание.Расписание = Расписание;
		Задание.Записать();
		
		ИдентификаторРегламентногоЗадания = Задание.УникальныйИдентификатор;
		
	Иначе
		
		ПараметрыЗадания = Новый Структура();
		ПараметрыЗадания.Вставить("Использование", Истина);
		ПараметрыЗадания.Вставить("ИмяМетода" ,Метаданные.РегламентныеЗадания.ОбменССайтом.ИмяМетода);
		ПараметрыЗадания.Вставить("Параметры" ,Параметры);
		ПараметрыЗадания.Вставить("Расписание",Расписание);
		
		Задание = ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
		ИдентификаторРегламентногоЗадания = Задание.УникальныйИдентификатор();
		
	КонецЕсли;
	
	Возврат ИдентификаторРегламентногоЗадания;
	
КонецФункции

// Возвращает идентификатор задания очереди (для сохранения в данных информационной базы).
//
// Задание - СправочникСсылка.ОчередьЗаданийОбластейДанных.
//
// Возвращаемое значение: УникальныйИдентификатор.
//
Функция ПолучитьИдентификаторЗадания(Знач Задание) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Задание.УникальныйИдентификатор();
	
КонецФункции

// Устанавливает параметры регламентного задания или задания очереди заданий.
//
// Параметры:
//  Задание - СправочникСсылка.ОчередьЗаданийОбластейДанных,
//  Использование - булево, флаг использования регламентного задания,
//  КодУзла - Строка - Код узла плана обмена
//  НаименованиеУзла - Строка - Наименование узла плана обмена
//  Расписание - РасписаниеРегламентногоЗадания.
//
Процедура УстановитьПараметрыЗадания(Задание, Использование, КодУзла, НаименованиеУзла, Расписание) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Параметры = Новый Массив;
	Параметры.Добавить(КодУзла);
	
	Если ТипЗнч(Задание) = Тип("РегламентноеЗадание") Тогда
		
		Задание.Использование = Истина;
		Задание.Ключ = Строка(Новый УникальныйИдентификатор);
		Задание.Наименование = НаименованиеУзла;
		Задание.Параметры = Параметры;
		Задание.Расписание = Расписание;
		Задание.Записать();
		
	Иначе
		
		Если Задание = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыЗадания = Новый Структура();
		ПараметрыЗадания.Вставить("Использование", Использование);
		ПараметрыЗадания.Вставить("ИмяМетода", Метаданные.РегламентныеЗадания.ОбменССайтом.ИмяМетода);
		ПараметрыЗадания.Вставить("Параметры", Параметры);
		ПараметрыЗадания.Вставить("Ключ", Метаданные.РегламентныеЗадания.ОбменССайтом.Ключ);
		ПараметрыЗадания.Вставить("Расписание", Расписание);
		
		ОчередьЗаданий.ИзменитьЗадание(Задание, ПараметрыЗадания);
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает параметры задания очереди заданий.
//
// Параметры:
//  Задание - СправочникСсылка.ОчередьЗаданийОбластейДанных.
//
// Возвращаемое значение: Структура, описания ключей - см. описание возвращаемого значения
//  для функции ОчередьЗаданий.ПолучитьЗадания().
//
Функция ПолучитьПараметрыЗадания(Знач Задание) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат ОчередьЗаданий.ПолучитьЗадания(Новый Структура("Идентификатор", Задание))[0];
	
КонецФункции

// Выполняет поиск задания очереди по идентификатору (предположительно, сохраненному в данных
// информационной базы).
//
// Параметры: Идентификатор - УникальныйИдентификатор.
//
// Возвращаемое значение: СправочникСсылка.ОчередьЗаданийОбластейДанных, РегламентноеЗадание.
//
Функция НайтиЗадание(Знач Идентификатор) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не РаботаВМоделиСервиса.РазделениеВключено() Тогда
		
		Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
		Возврат Задание;
		
	Иначе
		
		Задание = Справочники.ОчередьЗаданийОбластейДанных.ПолучитьСсылку(Идентификатор);
		Если ОбщегоНазначения.СсылкаСуществует(Задание) Тогда
			Возврат Задание;
		Иначе
			Возврат Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

// Удаляет регламентное задание или задание очереди заданий.
//
// Параметры:
//   Задание - РегламентноеЗадание, СправочникСсылка.ОчередьЗаданийОбластейДанных.
//
Процедура УдалитьЗадание(Знач Задание) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(Задание) = Тип("РегламентноеЗадание") Тогда
		Задание.Удалить();
	ИначеЕсли ТипЗнч(Задание) = Тип("СправочникСсылка.ОчередьЗаданийОбластейДанных") Тогда
		ОчередьЗаданий.УдалитьЗадание(Задание);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
