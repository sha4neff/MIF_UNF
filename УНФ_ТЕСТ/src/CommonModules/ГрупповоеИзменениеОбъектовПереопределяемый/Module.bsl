///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определить объекты метаданных, в формах списков которых
// будут выведены команды объединения дублей и замены ссылок
// см. ПоискИУдалениеДублейКлиент.ОбъединитьВыделенные и ПоискИУдалениеДублейКлиент.ЗаменитьВыделенные
// 
// Параметры:
//	Объекты - Массив из ОбъектМетаданных
//
// Пример:
//	Объекты.Добавить(Метаданные.Справочники._ДемоНоменклатура);
//	Объекты.Добавить(Метаданные.Справочники._ДемоКонтрагенты);
//
Процедура ПриОпределенииОбъектовСКомандойГрупповогоИзмененияОбъектов(Объекты) Экспорт

	

КонецПроцедуры

// Определить объекты метаданных, в модулях менеджеров которых ограничивается возможность 
// редактирования реквизитов при групповом изменении.
//
// Параметры:
//   Объекты - Соответствие - в качестве ключа указать полное имя объекта метаданных,
//                            подключенного к подсистеме "Групповое изменение объектов". 
//                            Дополнительно в значении могут быть перечислены имена экспортных функций:
//                            "РеквизитыНеРедактируемыеВГрупповойОбработке",
//                            "РеквизитыРедактируемыеВГрупповойОбработке".
//                            Каждое имя должно начинаться с новой строки.
//                            Если указано "*", значит, в модуле менеджера определены обе функции.
//
// Пример: 
//   Объекты.Вставить(Метаданные.Документы.ЗаказПокупателя.ПолноеИмя(), "*"); // определены обе функции.
//   Объекты.Вставить(Метаданные.БизнесПроцессы.ЗаданиеСРолевойАдресацией.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
//   Объекты.Вставить(Метаданные.Справочники.Партнеры.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке
//		|РеквизитыНеРедактируемыеВГрупповойОбработке");
//
Процедура ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты) Экспорт
	
	Объекты.Вставить(Метаданные.ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.АвансовыйОтчетПрисоединенныеФайлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.Валюты.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ВариантыОтчетов.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ВерсииФайлов.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ВидыКонтактнойИнформации.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ВнешниеПользователи.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ГруппыВнешнихПользователей.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ГруппыДоступа.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ДоговорыКонтрагентовПрисоединенныеФайлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ДополнительныеОтчетыИОбработки.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ЗаданиеНаРаботуПрисоединенныеФайлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ЗаказПокупателяПрисоединенныеФайлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ЗаказПоставщикуПрисоединенныеФайлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ЗначенияСвойствОбъектов.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ЗначенияСвойствОбъектовИерархия.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ИдентификаторыОбъектовМетаданных.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ИнвентаризацияЗапасовПрисоединенныеФайлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.КлассификаторБанков.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.КонтактныеЛица.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.Контрагенты.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.КонтрагентыПрисоединенныеФайлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.Лиды.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.НаборыДополнительныхРеквизитовИСведений.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.Номенклатура.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.НоменклатураПрисоединенныеФайлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.Организации.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ОрганизацииПрисоединенныеФайлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ПапкиФайлов.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.Пользователи.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ПользовательскиеНастройкиОтчетов.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ПоступлениеНаСчетПрисоединенныеФайлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ПредопределенныеВариантыОтчетов.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ПриходнаяНакладнаяПрисоединенныеФайлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ПрофилиГруппДоступа.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.РасходСоСчетаПрисоединенныеФайлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.СобытиеПрисоединенныеФайлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.СообщенияСистемы.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.СпецификацииПрисоединенныеФайлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.СтраныМира.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.СценарииОбменовДанными.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.СчетНаОплатуПоставщикаПрисоединенныеФайлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.СчетФактураПолученныйПрисоединенныеФайлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.СчетФактураПрисоединенныеФайлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.ТомаХраненияФайлов.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.УчетныеЗаписиЭлектроннойПочты.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.Файлы.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	Объекты.Вставить(Метаданные.Справочники.Спецификации.ПолноеИмя(), "РеквизитыРедактируемыеВГрупповойОбработке");
	
КонецПроцедуры

#КонецОбласти
