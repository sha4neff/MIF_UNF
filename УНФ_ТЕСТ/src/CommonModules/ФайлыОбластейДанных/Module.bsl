
#Область ПрограммныйИнтерфейс

// Параметры:
//	Типы - см. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.Типы
//
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
	Типы.Добавить(Метаданные.РегистрыСведений.ФайлыОбластейДанных);
	
КонецПроцедуры

// Обработчик регламентного задания "УдалениеВременныхФайловОбластейДанных".
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура УдалениеВременныхФайловОбластейДанных() Экспорт
КонецПроцедуры

// Возвращает имя, размер, расположение или двоичные данные файла по идентификатору.
// Если файл хранится на диске, в значение ПолноеИмя возвращается расположение файла.
// Если файл хранится в информационной базе, в значение Данные возвращаются двоичные данные. 
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
//  Идентификатор - Строка - идентификатор файла (длина - 36).
// 
// Возвращаемое значение:
//  Структура - описание файла, см. НовыйОписаниеФайла:
//	 * ИмяФайла - Строка - имя файла
//	 * Размер - Число - размер файла в байтах
//	 * ПолноеИмя - Строка, Неопределено - расположение файла в томе.
//	 * Данные - ДвоичныеДанные, Неопределено - двоичные данные файла.
//	 * CRC32 - Число - контрольная сумма данных файла.
//	 * УстановитьВременныйПриПолучении - Булево - признак временного при получении.
//
Функция ОписаниеФайла(Знач Идентификатор) Экспорт
КонецФункции

// Возвращает двоичные данные файла по идентификатору.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
//  Идентификатор - Строка - идентификатор файла (длина - 36).
//
// Возвращаемое значение:
//  ДвоичныеДанные - двоичные данные файла.
//
Функция ДвоичныеДанныеФайла(Знач Идентификатор) Экспорт
КонецФункции

// Сохраняет данные как запись о файле в регистре сведений ФайлыОбластейДанных.
// Если параметр Данные = Неопределено, должен быть заполнен параметр ПолноеИмя = полное имя файла с путем.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  Имя - Строка - имя файла в хранилище.
//  Данные - ДвоичныеДанные, Строка, Неопределено - двоичные данные файла, если ПолноеИмя = Неопределено.
//  ПолноеИмя - Строка, Неопределено - полное имя файла с путем, если Данные = Неопределено.
//  Временный - Булево - признак временного файла (будет удален по заданному расписанию рег. задания УдалениеВременныхФайловОбластейДанных)
//  УстановитьВременныйПриПолучении - Булево - устанавливать признак временного файла при первом получении.
//
// Возвращаемое значение:
//  УникальныйИдентификатор - Идентификатор файла.
//
Функция ЗагрузитьФайл(
	Знач Имя, 
	Данные = Неопределено, 
	ПолноеИмя = Неопределено, 
	Временный = Ложь, 
	УстановитьВременныйПриПолучении = Ложь) Экспорт
КонецФункции

// Удалить файл из информационной базы
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторФайла - УникальныйИдентификатор -  идентификатор удаляемого файла.
//  УдалятьЕслиНаДиске - Булево - если Ложь и хранение на диске, регистрируется как временный и с диска не удаляется.
//
// Возвращаемое значение:
//  Булево - Успешность удаления.
//
Функция УдалитьФайл(Знач ИдентификаторФайла, Знач УдалятьЕслиНаДиске = Истина) Экспорт
КонецФункции

// Устанавливает у файла признак "Временный" = Истина.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторФайла - УникальныйИдентификатор -  идентификатор файла.
// Возвращаемое значение:
//	Булево - Истина, если установка удалась, Ложь - в противном случае.
Функция УстановитьПризнакВременного(Знач ИдентификаторФайла) Экспорт
КонецФункции

// Помещает данные файла во временное хранилище и возвращает описание
// для сохранения или открытия файла.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИдентификаторФайла - УникальныйИдентификатор - идентификатор файла. 
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор формы для помещения.
// 
// Возвращаемое значение:
//  ОписаниеПередаваемогоФайла - ОписаниеПередаваемогоФайла - описание для сохранения или открытия файла.
//
Функция ОписаниеПередаваемогоФайла(ИдентификаторФайла, ИдентификаторФормы) Экспорт
КонецФункции

#КонецОбласти
