///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "СПАРК".
// ОбщийМодуль.СПАРКРискиКлиентПовтИсп.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Определяет возможность использования сервиса в соответствии с текущим
//  режимом работы и правами пользователя.
//
// Возвращаемое значение:
//  Булево - Истина - использование разрешено, Ложь - в противном случае.
//
Функция ИспользованиеРазрешено() Экспорт

	Возврат СПАРКРискиВызовСервера.ИспользованиеРазрешено();

КонецФункции

Функция СправочникиКонтрагенты() Экспорт

	Возврат СПАРКРискиВызовСервера.СправочникиКонтрагенты();

КонецФункции

#КонецОбласти
